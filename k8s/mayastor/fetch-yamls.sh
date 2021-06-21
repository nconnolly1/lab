#!/usr/bin/env bash

TAG=
COMMIT=
REGISTRY=

CI_REGISTRY="ci-registry.mayastor-ci.mayadata.io/mayadata"
DOCKER_REGISTRY="mayadata"

usage () {
	echo "Usage: fetch-yamls.sh [tag|commit|build]"
	exit 1
}

get_build_commit () {
	local build="$1"
	local details="/tmp/build-$$"

	echo "Finding commit from build log ..."

	curl -s -X POST -L --user "$JENKINS_AUTH" \
		"https://mayastor-ci.mayadata.io/job/Mayastor/job/develop/${build}" \
		--output "${details}"

	if [ ! -f "${details}" ]
	then
		echo "Error: Unable to download build details"
		exit 1
	fi

	COMMIT=$(sed -n -e"/Revision.*:/s?^.*Revision.*: ??p" < "${details}")
	COMMIT="${COMMIT:0:12}"

	if [ -z "$COMMIT" ]
	then
		echo "Error: Unable to determine commit for build"
		exit 1
	fi

	echo "Build is based on commit ${COMMIT}"
	rm -f "${details}"
}

get_docker_commit () {
	local reg="https://index.docker.io/v2/mayadata/mayastor"
	local accept="Accept: application/vnd.docker.distribution.manifest.v2+json"

	echo "Searching Docker registry for commit matching ${TAG} ..."

	token=$(curl -s -L "https://auth.docker.io/token?service=registry.docker.io&scope=repository:mayadata/mayastor:pull" |\
		sed -n -e's?[", ]??g' -e'/^token:/s?^token:??p')

	manifest=$(curl -s -L --header "Authorization: Bearer ${token}" \
		--header "${accept}" "${reg}/manifests/${TAG}")

	[[ "$manifest" = *MANIFEST_UNKNOWN* ]] && return

	digest="$(printf "%s" "$manifest" | sha256sum)"

	tags=$(curl -s -L --header "Authorization: Bearer ${token}" \
		--header "${accept}" "${reg}/tags/list" |\
		sed -e's?["{}]??g;s?\[??g;s?\]??g;s?,?\n?g' -e's?^.*tags:??' |\
		sed -n -e'/^[0-9a-f]\{12\}$/p')

	for t in ${tags}
	do
		x="$(curl -s -L --header "Authorization: Bearer ${token}" \
			--header "${accept}" "${reg}/manifests/${t}" | sha256sum)"

		if [[ "$x" = "$digest" ]]
		then
			echo "Using commit ${t} for ${TAG}"
			COMMIT="${t}"
			TAG="${t}"
			return
		fi
	done
}

get_ci_commit () {
	local reg="ci-registry.mayastor-ci.mayadata.io/v2/mayadata/mayastor"

	echo "Searching CI registry for commit matching ${TAG} ..."

	manifest=$(curl -s -L "${reg}/manifests/${TAG}")
		
	[[ "$manifest" = *MANIFEST_UNKNOWN* ]] && return

	digest="$(printf "%s" "$manifest" | grep blobSum | sha256sum)"

	tags=$(curl -s -L "${reg}/tags/list" |\
		sed -e's?["{}]??g;s?\[??g;s?\]??g;s?,?\n?g' -e's?^.*tags:??' |\
		sed -n -e'/^[0-9a-f]\{12\}$/p')

	for t in ${tags}
	do
		x="$(curl -s -L "${reg}/manifests/${t}" | grep blobSum | sha256sum)"
	
		if [[ "$x" = "$digest" ]]
		then
			echo "Using commit ${t} for ${TAG}"
			COMMIT="${t}"
			TAG="${t}"
			return
		fi
	done
}

find_build_images () {
	TAG="$1"

	echo "Checking Docker registry for ${TAG} ..."
	
	if curl -s -f -lSL "https://index.docker.io/v1/repositories/mayadata/mayastor/tags/${TAG}" >/dev/null 2>&1
	then
		echo "Using image from Docker registry"
		REGISTRY="${DOCKER_REGISTRY}"
		if [ -z "$COMMIT" ]
		then get_docker_commit
		fi
		return
	fi

	echo "Checking CI registry for ${TAG} ..."
	
	if curl -s -f -lSL "https://ci-registry.mayastor-ci.mayadata.io/v2/mayadata/mayastor/manifests/${TAG}" >/dev/null 2>&1
	then
		echo "Using image from CI registry"
		REGISTRY="${CI_REGISTRY}"
		if [ -z "$COMMIT" ]
		then get_ci_commit
		fi
		return
	fi

	echo "Error: Unable to find build images for ${TAG}"
	exit 1
}

get_yaml_files () {
	local tar="/tmp/yamls-$$.tar.gz" 

	echo "Downloading yaml files for ${COMMIT} ..."
	curl -s -L "http://github.com/openebs/mayastor/archive/${COMMIT}.tar.gz" --output "${tar}"

	size="$(stat --printf="%s" "${tar}")"

	if [ ! -f "${tar}" ] || [[ $size -lt 100 ]]
	then
		echo "Error: Unable to download yaml files for ${COMMIT}"
		exit 1
	fi

	rm -rf yamls
	mkdir yamls
	tar xzf "${tar}" --wildcards --strip-components=2 -C yamls "*/deploy"
	tar xzf "${tar}" --wildcards --strip-components=4 -C yamls "*/csi/moac/crds/*pool.yaml"
	mv -f yamls/mayastorpool.yaml yamls/mayastorpoolcrd.yaml
	rm -f "${tar}"

	echo "Updating yaml files ..."

	egrep -Rl "image:.*mayadata/.*:" yamls | xargs -n 1 sed -i \
		-e"/image:.*mayadata\/.*:/s?\(image:  *\).*mayadata\(/[^:]*\):.*?\1${REGISTRY}\2:${TAG}?"

	egrep -R "image:.*mayadata/.*:" yamls
}

case "$1" in
[0-9a-f][0-9a-f][0-9a-f][0-9a-f]*)
	COMMIT="${1:0:12}"
	find_build_images "$1"
	;;

[0-9][0-9]*)
	if [ -z "${JENKINS_AUTH}" ]
	then
		echo 'Error: ${JENKINS_AUTH} must be set to email:api-token to use build number'
		echo 'Error: An api-token can be created on the Jenkins Configure page'
		exit 1
	fi

	get_build_commit "$1"
	find_build_images "${COMMIT}"
	;;

v[0-9]*)
	COMMIT="$1"
	find_build_images "$1"
	;;

[a-z]*)
	find_build_images "$1"
	;;

*)
	usage
	;;
esac

if [ -z "$COMMIT" ]
then
	echo "Error: Unable to find a commit matching $1"
	exit 1
fi

get_yaml_files
exit 0

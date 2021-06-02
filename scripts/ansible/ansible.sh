#!/usr/bin/env bash

TMPDIR=/tmp/ansible.$$
trap 'rm -rf "$TMPDIR"; exit 0' EXIT SIGINT
rm -rf "$TMPDIR"

mkdir -p "$TMPDIR/bin"
install "$(dirname "$0")/sudo.sh" "$TMPDIR/bin/sudo"
PATH="$TMPDIR/bin:$PATH"

if command -v cygpath >/dev/null 2>&1
then
	wslpath () { cygpath "$@"; }
fi

if command -v wslpath >/dev/null 2>&1; then :
else
	wslpath () {
		[[ "$1" = "-u" ]] && shift
		echo "$1" | sed -e's?\\?/?g' -e's?^\([A-Za-z]\):?/mnt/\L\1?'
	}
fi

dequote () {
	if [[ "$1" = [\"\']*[\"\'] ]]
	then echo "${1:1:-1}"
	else echo "$1"
	fi
}

copy_key_file () {
	KEYFILE="$(mktemp -p "$TMPDIR")"
	x="$(wslpath -u "$1")"
	tr -d '\r' < "$x" > "$KEYFILE"
	chmod 0600 "$KEYFILE"
}

copy_inventory_file () {
	tr -d '\r' < "$1" |
	while IFS='' read -r line
	do
		KEYARG="ansible_ssh_private_key_file"
		file=$(echo "$line" | sed -n -e"s?.*$KEYARG='\([^']*\)'.*?\1?p")
		if [ -n "$file" ]
		then
			copy_key_file "$file"
			line="$(echo "$line" | sed -E "s|$KEYARG='[^']*'|$KEYARG='$KEYFILE'|")"
		fi
		echo "$line" | sed -e's?\(ansible_user=[^ \\]*\\\)?\1\\?'
	done > "$2"
}

copy_inventory () {
	x="$(basename "$1")"
	INVENTORY="$TMPDIR/${x/ /_}"
	if [ -d "$1" ]
	then
		mkdir -p "$INVENTORY"
		for file in "$1"/*
		do copy_inventory_file "$file" "$INVENTORY/$(basename "$file")"
		done
	else
		copy_inventory_file "$1" "$INVENTORY"
	fi
}

# Adjust SSH arguments
get_ssh_args () {
	echo "$1" | sed -e"s?-o ControlMaster=[^ ]*??" \
		-e"s?-o ControlPersist=[^ ]*??" -e"s?-o UserKnownHostsFile=[^ ]*??" \
		-e"s?-o IdentitiesOnly==[^ ]*??" -e"s?^?-o ControlMaster=no ?" \
		-e"s?^?-o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes ?" \
		-e"s? *\$??"
}

get_option_arg () {
	if [[ $option = --*=* ]]
	then optarg="${option#*=}"
	else optarg="${argv[((++optind))]}"
	fi

	optarg="$(dequote "$optarg")"
}

set_option_arg () {
	if [[ $option = --*=* ]]
	then argv[$optind]="${option%%=*}=$1"
	else argv[$optind]="$1"
	fi
}

is_split_arg () {
	c="${1#[^\'\"\{]*=}"
	c="${c%%[^\'\"\{]*}"
	c="${c:0:1}"
	[[ -n "$c" ]] && [[ "${1: -1:1}" != "${c/\{/\}}" ]]
}

argv=( )

# Rejoin split arguments
for ((i = 1 , j = 0; i <= $# ; j++))
do
	argv[j]="${*:i++:1}"
	while [[ $i -le $# ]] && is_split_arg "${argv[j]}"
	do argv[j]="${argv[j]} ${*:i++:1}"
	done
done

for ((optind = 1 ; optind < ${#argv[@]} ; optind++))
do
	option="${argv[$optind]}"

	case "$option" in
	--private-key* | --key-file*)
		get_option_arg
		copy_key_file "$(wslpath -u "$optarg")"
		set_option_arg "$KEYFILE"
		;;

	-i | --inventory*)
		get_option_arg
		copy_inventory "$(wslpath -u "$optarg")"
		set_option_arg "$INVENTORY"
		;;

	--vault-password-file* | --vault-pass-file*)
		get_option_arg
		set_option_arg "$(wslpath -u "$optarg")"
		;;

	--ssh-common-args* | --sftp-extra-args* | --scp-extra-args* | --ssh-extra-args*)
		get_option_arg
		set_option_arg "$(get_ssh_args "$optarg")"
		;;

	-M | --module-path*)
		get_option_arg
		echo "Warning: Module path is not supported" 1>&2
		;;

	-e | --extra-vars*)
		get_option_arg

		case "$optarg" in
		ansible_ssh_private_key_file=*)
			copy_key_file "$(dequote "${optarg#*=}")"
			set_option_arg "${optarg%%=*}=$KEYFILE"
			;;
		esac
		;;

	*\\*)
		_path="$(wslpath -u "$option")"
		[ -e "$_path" ] && set_option_arg "$_path"
		;;
	esac
done

ANSIBLE_HOST_KEY_CHECKING=false
export ANSIBLE_HOST_KEY_CHECKING

ANSIBLE_SSH_ARGS="$(get_ssh_args "$ANSIBLE_SSH_ARGS")"
export ANSIBLE_SSH_ARGS

"${argv[@]}"

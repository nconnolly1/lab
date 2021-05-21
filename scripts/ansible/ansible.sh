#!/usr/bin/env bash

args=( "$@" )

TMPDIR=/tmp/ansible.$$
trap 'rm -rf "$TMPDIR"; exit 0' EXIT SIGINT
rm -rf "$TMPDIR"

if command -v cygpath >/dev/null 2>&1
then
	wslpath () { cygpath "$@"; }
	mkdir -p "$TMPDIR/bin"
	install "$(dirname "$0")/sudo.sh" "$TMPDIR/bin/sudo"
	PATH="$TMPDIR/bin:$PATH"
fi

copy_inventory_file () {
	tr -d '\r' < "$1" |
	while IFS='' read -r line
	do
		KEYARG="ansible_ssh_private_key_file"
		KEYFILE=$(echo "$line" | sed -n -e"s?.*$KEYARG='\([^']*\)'.*?\1?p")
		if [ -n "$KEYFILE" ]
		then
			NEWFILE="$TMPDIR/"$(uuidgen)
			tr -d '\r' < "$(wslpath -u "$KEYFILE")" > "$NEWFILE"
			chmod 0400 "$NEWFILE"
			echo "$line" | sed -E "s|$KEYARG='[^']*'|$KEYARG='$NEWFILE'|"
		else
			echo "$line"
		fi
	done > "$2"
}

copy_inventory () {
	if [ -d "$1" ]
	then
		mkdir -p "$2"
		for file in "$1"/*
		do copy_inventory_file "$file" "$2/$(basename "$file")"
		done
	else
		copy_inventory_file "$1" "$2"
	fi
}

for ((i = 1 ; i < ${#args[@]} ; i++))
do
	arg="${args[$i]}"

	case "$arg" in
	--inventory-file=*)
		INVENTORY=$(wslpath -u "$(echo "$arg" | sed -e"s?^[^=]*=??" -e"s?^[\"']??" -e"s?[\"']\$??")")
		copy_inventory "$INVENTORY" "$TMPDIR/$(basename "$INVENTORY")"
		args[$i]="--inventory-file=$TMPDIR/$(basename "$INVENTORY")"
		;;
	esac
done

# Disable ssh ControlMaster
ANSIBLE_SSH_ARGS=$(echo "$ANSIBLE_SSH_ARGS" | sed \
	-e"s?ControlMaster=[^ ]*?ControlMaster=no?" \
	-e"s?-o ControlPersist=[^ ]*??" -e"s? *\$??" \
	)

"${args[@]}"

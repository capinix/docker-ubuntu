#!/usr/bin/env bash

changed=FALSE

config () {
	# $1 is the configuration option
	# $2 is the setting
	file=/etc/ssh/sshd_config

	if grep -Eiq "^[[:space:]]*${1}[[:space:]]+\w+\b" "${file}"
	then
		if ! grep -Eiq "^[[:space:]]*${1}[[:space:]]+${2}\b" "${file}"
		then
			sed -i "s/^[[:space:]]*${1}[[:space:]]+\w\b.*/${1} ${2}/gi" "${file}"
			changed=TRUE
		fi
	else
		echo "${1} ${2}" >> "${file}"
		changed=TRUE
	fi
}

config PubkeyAuthentication   yes
config PasswordAuthentication no 
config PermitRootLogin        yes

# reload ssh
if changed
then
	kill -SIGHUP $(pgrep -f "sshd -D")
fi

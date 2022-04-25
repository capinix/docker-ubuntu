#!/usr/bin/env bash

# Source all the environment variables provided in the files from env
if [ -d /root/env ] # we dont want errors if the folder does not exist
then
	if ls /root/env/*.env &>/dev/null # make sure we have some eligible files
	then
		for f in /root/env/*.env
		do
			source $f
		done
		cat /root/env/* >> /etc/environment
	fi
fi

# Set the time zone --TODO better
if [ -z "$TZ" ]
then
	TZ=UTC
fi
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update the system
apt-get update  -qq
apt-get install -qq -y locales apt-utils
locale-gen en_US.UTF-8
apt-get upgrade -qq -y

# Install extra packages, consider removing this to make a leaner system
yes | unminimize

# Install build utilities and common tools
apt-get -qq -y install bc byobu curl openjdk-8-jdk screen ssh sudo tmux vim 
apt-get -qq -y install make build-essential gcc git jq chrony golang
apt-get -qq -y autoremove
apt-get -qq -y clean

# allow the public key given in the PUBLIC_KEY environment variable
# and any keys in the authorized_keys supplied in the prv folder
# ssh access to the root user
# also allow the server to ssh into itself might be useful later
[ -f /root/prv/authorized_keys ]  || touch /root/prv/authorized_keys
[ -z "$PUBLIC_KEY" ]              || echo "$PUBLIC_KEY" >> /root/prv/authorized_keys
[ -d /root/.ssh ]                 || mkdir /root/.ssh
[ -f /root/.ssh/authorized_keys ] || touch /root/.ssh/authorized_keys
cat /root/.ssh/authorized_keys    >> /root/prv/authorized_keys
[ -f /root/.ssh/id_rsa.pub ]      || ssh-keygen -b 2048 -f /root/.ssh/id_rsa -q -N ''

cat /root/.ssh/id_rsa.pub >> /root/prv/authorized_keys
cat /root/prv/authorized_keys | sort -u > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# Create a system user to run whatever application we want to run
# The user name can be customized with the APP_USER environment variable
# User only accessible via ssh and public key
# user can sudo without a password
[ -z "$APP_USER" ] && APP_USER=node
id "$APP_USER" &>/dev/null || useradd -rm -d /home/${APP_USER} -s /bin/bash ${APP_USER}
DEST="/home/${APP_USER}/.ssh"
mkdir -p "${DEST}" &>/dev/null
if [ -d "${DEST}" ]; then
	cat /root/.ssh/authorized_keys >> "${DEST}/authorized_keys"
	chown -R ${APP_USER}:${APP_USER} "${DEST}"
	chmod 700 "${DEST}"
	chmod 600 "${DEST}/authorized_keys"
fi
echo "${APP_USER}  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

file=disable-ssh-password.sh
srce="/root/src/${file}"
dest="/home/${APP_USER}/${file}"
if [ -f "${srce}" ]
then
	cp "${srce}" "${dest}"
	chown ${APP_USER}:${APP_USER} "${dest}"
	chmod 775 "${dest}"
fi

# Create the ssh run directory
mkdir -p /var/run/sshd

# Source any files in the inc folder
# Here we can further customize the image by adding scripts 
if [ -d /root/inc ]
then
	if ls /root/inc/*.sh &>/dev/null
	then
		for f in /root/inc/*.sh
		do
			source $f
		done
	fi
fi

# Remove the prv folder
[ -d /root/prv ] &&	rm -rf /root/prv

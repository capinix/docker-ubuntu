#!/usr/bin/env bash

cd /root
source /root/env.sh
echo /root/env.sh >> /etc/environment

[ -z "$TC" ] && TC=UTC
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

apt-get update  -q
apt-get upgrade -q -y
apt-get install -q -y locales apt-utils
locale-gen en_US.UTF-8

yes | unminimize

# Install utilities
apt-get -q -y install bc byobu curl openjdk-8-jdk screen ssh sudo tmux vim 
apt-get -q -y install make build-essential gcc git jq chrony golang
apt-get -q -y autoremove
apt-get -q -y clean

[ -f /root/authorized_keys ]      || touch /root/authorized_keys
[ -z "$PUBLIC_KEY" ]              || echo "$PUBLIC_KEY" >> /root/authorized_keys
[ -d /root/.ssh ]                 || mkdir /root/.ssh
[ -f /root/.ssh/authorized_keys ] || touch /root/.ssh/authorized_keys
cat /root/.ssh/authorized_keys    >> /root/authorized_keys
if [ ! -f /root/.ssh/id_rsa.pub ]; then
	ssh-keygen -b 2048 -f /root/.ssh/id_rsa -q -N ''
fi
cat /root/.ssh/id_rsa.pub >> /root/authorized_keys
cat /root/authorized_keys | sort -u > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

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

mkdir -p /var/run/sshd

[ -f /root/authorized_keys ] &&	rm /root/authorized_keys
[ -f /root/env.sh ]      && rm /root/env.sh

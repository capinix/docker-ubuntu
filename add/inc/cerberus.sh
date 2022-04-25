#!/usr/bin/env bash

cd /opt
git clone https://github.com/cerberus-zone/cerberus.git
cd cerberus
git fetch -a
git checkout v1.0.1
make install
cp bin/cerberusd /usr/local/bin

su ${APP_USER} -c  "cerberusd init ${MONIKER_NAME} --chain-id ${CHAIN_ID}"

cp /root/src/{node,state_sync,tmux,tstatus}.sh /home/${APP_USER}
chown ${APP_USER}:${APP_USER} /home/${APP_USER}/{node,state_sync,tmux,tstatus}.sh
chmod 755 /home/${APP_USER}/{node,state_sync,tmux,tstatus}.sh

sudo -i -u ${APP_USER} ./node.sh
sudo -i -u ${APP_USER} ./state_sync.sh


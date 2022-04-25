# docker-ubuntu/

This ia a base ubuntu server image for our docker deployments.

It has basic server admin and development tools installed.

A system user is created, the name of this user can be specified by setting the APP_USER environment variable in config/env.sh. it defaults to node

SSH access is enabled for public keys stored in the config/authorized_keys file or specified as the PUBLIC_KEY environment variable in the config/env.sh fiile

Other environment variables can be set in config/env.sh

When run without arguments, will spawn an ssh server for remote management.

# Usage
To make a container called ubuntu, exposing it's ssh server on our port 2222, run it and detach from it

docker run -d --name ubuntu -p 2222:22/tcp capinix/ubuntu

# To test the ssh connection

ssh root@localhost -p 2222

# Build the image 
docker build -t capinix/ubuntu  .

# Other useful commands

docker build -t capinix/ubuntu --pull --no-cache .

ssh-keygen -f "~/.ssh/known_hosts" -R "[localhost]:2222"


# docker-ubuntu

This ia a base ubuntu server image for our docker deployments.
when run without arguments, will spawn an ssh server for 
remote management.
ssh access is only enabled for public keys given either
as PUBLIC_KEY environment varible specified in config/env.sh or
one of the public keys specified in the optional config/authorized_keys

any environment variables needed to be added to config/env.sh
an optional authorized_keys file could also be added to the config path

a system user is created, the name if this user can be specified by setting
the APP_USER environment variable in config/env.sh. it defaults to node

To use
docker run -d --name ubuntu -p 2222:22/tcp capinix/ubuntu





useful commands do not use 

# Build the image 
docker build -t capinix/ubuntu  .

# Build the image redownloading all 
docker build -t capinix/ubuntu --pull --no-cache .

# make a container from the image and detach exposing the ssh port on 2222
docker run -d --name ubuntu -p 2222:22/tcp capinix/ubuntu

ssh root@localhost -p 2222

ssh-keygen -f "~/.ssh/known_hosts" -R "[localhost]:2222"


# env
Here we set environment variables needed for the image
a standard shell file format which will be sourced and inserted
into the /etc/environment.

VARIABLE=VALUE

be careful not to clobber your variables over multiple files
files read must have the .env extension
other files will be ignored
example: public_key.env


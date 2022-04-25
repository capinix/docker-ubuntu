# env
Here we set environment variables needed for the image.

The file contains standard bash variable assignments of the form

VARIABLE=VALUE

Files must have an .env extension, else they are ignored

example

public_key.env

Be careful not to clobber your variables over multiple files

one of these files is a good place to put required environment variables like

PUBLIC_KEY=

APP_USER=

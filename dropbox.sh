#!/bin/sh
#
# Starts Dropbox server on command-line, keeps watching its status.
# Once you hit CTRL-C, stops the server.
#

dropbox start
watch -n5 dropbox status


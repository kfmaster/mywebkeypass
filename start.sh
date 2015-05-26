#!/bin/bash
# Using supervisord to control subprocess in this container

echo "Starting mywebkeepass container ..."
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

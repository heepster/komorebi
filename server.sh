#!/usr/bin/env bash

set -o errexit

COMMAND="${COMMAND:-date}"
PORT=${PORT:-1500}
HTTP_START="HTTP/1.1"
HTTP_GOOD="200 OK"
HTTP_BAD="500 Internal Error"
NETCAT_PACKAGE='netcat-openbsd'

if which apt-get &>/dev/null; then
    if ! dpkg -s $NETCAT_PACKAGE &>/dev/null; then
        echo "Installing '$NETCAT_PACKAGE'"
        sudo apt-get -y install $NETCAT_PACKAGE
    fi
fi

trap "exit" INT

echo "Starting HTTP server on port ${PORT}"
echo "Command: '${COMMAND}'"

while true; do
    if eval $COMMAND &>/dev/null; then 
        RESP="${HTTP_START} ${HTTP_GOOD} \n\n "
    else
        RESP="${HTTP_START} ${HTTP_BAD} \n\n "
    fi
    echo -e "${RESP}" | nc -l "${PORT}"
done
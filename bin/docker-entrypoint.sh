#!/bin/bash

if [ "$1" == "openfortivpn" ]; then
    add-routes.sh &
fi

"$@"

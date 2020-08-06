#!/bin/bash

if [[ "$1" = "" ]]; then
  ssserver -p "${port:-10111}" -k "${password:-ladder@19885}" -m "${method:-chacha20-ietf-poly1305}" start
else
  exec "$@"
fi

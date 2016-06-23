#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
KEYDIR="$( cd "${DIR}/../keys" && pwd )"

echo "## KEYDIR=${KEYDIR}"

if [ ! -e "${KEYDIR}/root_rsa" ]; then
  rm -f "${KEYDIR}/root_rsa.pub"
  ssh-keygen -t rsa -f "${KEYDIR}/root_rsa" -q -N "" -C "bitswarm_insecure"
fi

echo "#### root_rsa.pub:"
cat "${KEYDIR}/root_rsa.pub"

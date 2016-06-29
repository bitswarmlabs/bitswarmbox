#!/bin/bash
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
minimal_apt_get_install='apt-get install -y'

if [ -e /tmp/keys/root_rsa ]; then
  echo '## RSA keypair preloaded'
  mv /tmp/keys/root_rsa /root/.ssh/id_rsa
  mv /tmp/keys/root_rsa.pub /root/.ssh/id_rsa.pub
  chmod 600 /root/.ssh/id_rsa*
else
  echo '## Creating /root RSA keypair'
  rm -f /root/.ssh/id_rsa
  rm -f /root/.ssh/id_rsa.pub
  ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -N "" -C "puppetmaster"
fi

#!/bin/bash
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
minimal_apt_get_install='apt-get install -y --no-install-recommends'

## Temporarily disable dpkg fsync to make building faster.
echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/02apt-speedup

apt-get update -q

$minimal_apt_get_install zsh vim git wget curl

echo "## zsh executable: `which zsh`"
echo "## vim executable: `which vi`"
echo "## git executable: `which git`"

mkdir -p /usr/local/bin
mkdir -p /usr/local/sbin

mkdir -p /root/.ssh
chmod 700 /root/.ssh


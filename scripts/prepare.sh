#!/bin/bash
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
minimal_apt_get_install='apt-get install -y'

set -e

# update the apt cache and packages
case $(lsb_release -cs) in
    'precise')
        apt-get clean
        rm -rf /var/lib/apt/lists/*
        apt-get clean
    ;;
    *)
    ;;
esac

apt-get -qy update
apt-get -qy upgrade

$minimal_apt_get_install zsh vim git wget curl

echo "## zsh executable: `which zsh`"
echo "## vim executable: `which vi`"
echo "## git executable: `which git`"

mkdir -p /usr/local/bin
mkdir -p /usr/local/sbin

mkdir -p /root/.ssh
chmod 700 /root/.ssh

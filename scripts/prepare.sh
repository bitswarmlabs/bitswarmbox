#!/bin/bash
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
minimal_apt_get_install='apt-get install -y'

set -e

os_distro=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
os_release=$(lsb_release -cs)

# update the apt cache and packages
case $os_release in
    'precise')
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24
        echo 'deb http://ppa.launchpad.net/git-core/ppa/ubuntu precise main' | sudo tee /etc/apt/sources.list.d/git.list
    ;;
    'trusty')
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24
        echo 'deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main' | sudo tee /etc/apt/sources.list.d/git.list
    ;;
    *)
    ;;
esac

apt-get -qy update

$minimal_apt_get_install git wget curl

apt-get -qy upgrade

mkdir -p /usr/local/bin
mkdir -p /usr/local/sbin

mkdir -p /root/.ssh
chmod 700 /root/.ssh

cp /etc/hosts /etc/hosts.orig

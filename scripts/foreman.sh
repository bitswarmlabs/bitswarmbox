#!/bin/bash
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
minimal_apt_get_install='apt-get install -y'

set -e

os_distro=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
os_release=$(lsb_release -cs)

echo "## Installing Foreman apt repos"
echo "deb http://deb.theforeman.org/ ${os_release} 1.12" > /etc/apt/sources.list.d/foreman.list
echo "deb http://deb.theforeman.org/ plugins 1.12" >> /etc/apt/sources.list.d/foreman.list
$minimal_apt_get_install ca-certificates
wget -q https://deb.theforeman.org/pubkey.gpg -O- | apt-key add -

apt-get update -qy
$minimal_apt_get_install foreman-installer

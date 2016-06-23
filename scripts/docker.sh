#!/bin/bash
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
minimal_apt_get_install='apt-get install -y --no-install-recommends'

os_distro=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
os_release=$(lsb_release -cs)

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ${os_distro}-${os_release} main" | sudo tee /etc/apt/sources.list.d/docker.list

apt-get update -qy

apt-cache policy docker-engine

$minimal_apt_get_install docker-engine

systemctl status docker

if [ PACKER_PROVISIONER == 'vagrant' ]; then
  usermod -aG docker vagrant
fi


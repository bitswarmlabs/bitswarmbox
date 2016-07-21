#!/bin/bash
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
minimal_apt_get_install='apt-get install -y --no-install-recommends'

# vagrant.sh aka Mitchell's old basebox postinstall.sh example
set -e

# mark the build time
date > /etc/vagrant_box_build_time

# install some oft used packages
$minimal_apt_get_install linux-headers-$(uname -r) build-essential
$minimal_apt_get_install zlib1g-dev libssl-dev
$minimal_apt_get_install python-software-properties python-setuptools python-dev

# configure password-less sudo
usermod -a -G sudo vagrant
echo "%vagrant ALL=NOPASSWD:ALL" > /tmp/vagrant
mv /tmp/vagrant /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# install the vagrant-provided ssh keys
mkdir -pm 700 /home/vagrant/.ssh
curl -Lo /home/vagrant/.ssh/authorized_keys \
  'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# under Ubuntu 16.04 (Xenial), networking gets lost on reboot
# this is because it's renamed to follow the PCI slot
case $(lsb_release -cs) in
    "xenial")
        sed -i "s/ens33/ens32/g" /etc/network/interfaces
    ;;
    *)
    ;;
esac

# clean up any artifacts
rm -f /home/vagrant/shutdown.sh

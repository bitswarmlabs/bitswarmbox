#!/bin/bash
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive

##
# Purge unnecessary data from the image to keep it small.
#
# Based on: https://gist.github.com/adrienbrault/3775253
##

# tidy up DCHP leases
echo "Cleaning up dhcp..."
rm /var/lib/dhcp/*

# make sure Udev doesn't block our network
# http://6.ptmc.org/?p=164
#echo "Cleaning up udev..."
#rm /etc/udev/rules.d/70-persistent-net.rules
#mkdir /etc/udev/rules.d/70-persistent-net.rules
#rm -rf /dev/.udev/
#rm /lib/udev/rules.d/75-persistent-net-generator.rules

# clean up apt
echo "Cleaning up apt..."
apt-get -qy autoremove
apt-get clean -qy
apt-get autoclean -qy

# nuke the bash history
echo "Removing bash history..."
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

# clean up the logs
echo "Cleaning up logs..."
find /var/log -type f | while read f; do echo -ne '' > $f; done;

if [ -e /etc/puppetlabs/puppet/ssl ]; then
    echo "Clearing out any generated Puppet SSL certs"
    set -x
    rm -rf /etc/puppetlabs/puppet/ssl/*
fi
if [ -e /etc/puppetlabs/puppetdb/ssl ]; then
    echo "Clearing out any generated PuppetDB SSL certs"
    set -x
    rm -rf /etc/puppetlabs/puppetdb/ssl/*
fi

echo "Reverting /etc/hosts"
cp /etc/hosts.orig /etc/hosts
rm -f /etc/hosts.orig

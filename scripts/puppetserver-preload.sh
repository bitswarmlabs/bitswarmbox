#!/bin/bash

echo "## Puppetserver Post Install Tasks: Install r10k puppet_gem and then run r10k puppetfile install in /etc/puppetlabs/code"

set -e

if [ ! -e /etc/puppetlabs/code/.r10k-bootstrapped ]; then
    puppet apply -e 'package { "r10k": provider => puppet_gem, ensure => installed } -> file { "/usr/bin/r10k": ensure  => link, target => "/opt/puppetlabs/puppet/bin/r10k", force => true }'
fi

r10k version

mkdir -p /etc/puppetlabs/code
cd /etc/puppetlabs/code
[ -e /tmp/Puppetfile ] &&  mv /tmp/Puppetfile .

if [ ! -e /etc/puppetlabs/code/.r10k-bootstrapped ]; then
    r10k puppetfile install -v && date > /etc/puppetlabs/code/.r10k-bootstrapped
fi

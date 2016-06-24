#!/bin/bash

echo "## Puppet Bootstrap Post Install Tasks: Install r10k puppet_gem and then run r10k puppetfile install in /opt/puppetlabs/puppet"

set -e

if [ ! -e /opt/puppetlabs/puppet/.r10k-bootstrapped ]; then
    puppet apply -e 'package { "r10k": provider => puppet_gem, ensure => installed } -> file { "/usr/bin/r10k": ensure  => link, target => "/opt/puppetlabs/puppet/bin/r10k", force => true }'
fi

r10k version

mkdir -p /opt/puppetlabs/puppet
cd /opt/puppetlabs/puppet
[ -e /tmp/Puppetfile ] &&  mv /tmp/Puppetfile .

if [ ! -e /opt/puppetlabs/puppet/.r10k-bootstrapped ]; then
    r10k puppetfile install -v && date > /opt/puppetlabs/puppet/.r10k-bootstrapped
fi

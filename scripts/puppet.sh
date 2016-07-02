#!/bin/bash
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
minimal_apt_get_install='apt-get install -y'

echo "## Installing Puppet (agent)"

set -e

cd /tmp

# see: http://docs.puppetlabs.com/guides/puppetlabs_package_repositories.html

# determine the os release
os_distro=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
os_release=$(lsb_release -cs)

# configure the puppet package sources
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-$os_release.deb
dpkg -i puppetlabs-release-pc1-$os_release.deb
apt-get -q update

# install puppet
$minimal_apt_get_install puppet-agent

echo "## Creating symlink for Puppet binaries in /usr/bin"
for f in $(find /opt/puppetlabs/bin -type l -or -type f); do
  ln -svf $(readlink -f "$f") /usr/bin/$(basename "$f")
done

echo "## Puppet executable $(which puppet) version $(puppet --version)"

echo "## Creating local alias for $(facter hostname) and $(facter fqdn)"
puppet apply -v -e 'host { $::hostname: ip => "127.0.0.1", host_aliases => [$::fqdn] }'

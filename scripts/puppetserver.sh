#!/bin/bash
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
minimal_apt_get_install='apt-get install -y --no-install-recommends'

echo "## Installing Puppet (server)"

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

# install puppetserver and friends
$minimal_apt_get_install puppet-agent puppetserver puppetdb puppetdb-termini

echo "## Creating symlink for Puppet binaries in /usr/bin"
for f in $(find /opt/puppetlabs/bin -type l -or -type f); do
  ln -svf $(readlink -f "$f") /usr/bin/$(basename "$f")
done

echo "## Puppet executable $(which puppet) version $(puppet --version)"
echo "## Puppetdb executable $(which puppetdb) version $(puppetdb --version)"

if [ -e /tmp/keys/root_rsa ]; then
  echo '## RSA keypair preloaded'
  mv /tmp/keys/root_rsa /root/.ssh/id_rsa
  mv /tmp/keys/root_rsa.pub /root/.ssh/id_rsa.pub
  chmod 600 /root/.ssh/id_rsa*
else
  echo '## Creating /root RSA keypair'
  rm -f /root/.ssh/id_rsa
  rm -f /root/.ssh/id_rsa.pub
  ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -N "" -C "puppetmaster"
fi

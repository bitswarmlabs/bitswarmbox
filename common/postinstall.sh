# postinstall.sh based upon Mitchell's old basebox example

# mark the build time
date > /etc/vagrant_box_build_time

# update the apt cache and packages
# this fixes an issue where the hashes are mismatched.
rm -R /var/lib/apt/lists/*
apt-get -qy update
apt-get -qy upgrade

# install some oft used packages
apt-get -qy install linux-headers-$(uname -r) build-essential
apt-get -qy install zlib1g-dev libssl-dev
apt-get -qy install python-software-properties python-setuptools python-dev
apt-get -qy install ruby1.9.3

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

# clean up any artifacts
rm -f /home/vagrant/shutdown.sh

exit

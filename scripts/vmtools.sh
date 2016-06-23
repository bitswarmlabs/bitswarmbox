#!/bin/bash
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
minimal_apt_get_install='apt-get install -y --no-install-recommends'

##
# Configure the relevant VM tools for this builder.
##

set -e

case $PACKER_BUILDER_TYPE in
    'virtualbox-iso')
        echo "Installing VirtualBox Guest Additions..."
        $minimal_apt_get_install dkms
        mount -o loop /home/vagrant/VBoxGuestAdditions.iso /mnt
        sh /mnt/VBoxLinuxAdditions.run
        umount /mnt

        rm -f /home/vagrant/VBoxGuestAdditions.iso
    ;;
    'vmware-iso')
        echo "Installing VMware Tools..."
        mkdir -p /mnt/cdrom
        mount -o loop /home/vagrant/linux.iso /mnt/cdrom

        cd /tmp
        tar -zxpf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/
        /tmp/vmware-tools-distrib/vmware-install.pl --force-install --default

        umount /mnt/cdrom
        rm -f /home/vagrant/linux.iso
    ;;
    *)
        printf "Nothing to do for the %s builder type.\n" $PACKER_BUILDER_TYPE
    ;;
esac

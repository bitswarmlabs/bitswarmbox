#!/bin/bash

echo "AWS provisioner cleanup"
cat /dev/null > /var/log/wtmp
rm /root/.ssh/authorized_keys

echo "Resetting /etc/hosts"
cp /etc/hosts.orig /etc/hosts
rm -f /etc/hosts.orig


exit

#!/bin/bash

echo "Resetting /etc/hosts"
cp /etc/hosts.orig /etc/hosts
rm -f /etc/hosts.orig

# zero any and all free space
echo "Cleaning free space..."
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# whiteout root
echo "Cleaning up /..."
#count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`;
dd if=/dev/zero of=/tmp/whitespace bs=1024;
rm /tmp/whitespace;

# whiteout /boot
echo "Cleaning up /boot..."
#count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
dd if=/dev/zero of=/boot/whitespace bs=1024;
rm /boot/whitespace;

# whiteout the swap
echo "Cleaning up swap partitions..."
swappart=`cat /proc/swaps | tail -n1 | awk -F ' ' '{print $1}'`
swapoff $swappart;
dd if=/dev/zero of=$swappart;
mkswap $swappart;
swapon $swappart;

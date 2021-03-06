#!/bin/bash

#echo "###### /root/.ssh/id_rsa.pub contents baked in:"
#cat /root/.ssh/id_rsa.pub

#rm -rf /etc/puppetlabs/ssl/*
#rm -rf /etc/puppetlabs/puppetdb/ssl/*

echo "## Generated Hiera files awaiting implementation by bsl_bootstrap init script:"

set -v
cat /etc/puppetlabs/code/bsl_bootstrap/hiera.yaml

for f in $(find /etc/puppetlabs/code/bsl_bootstrap/hieradata -type f); do
    cat $f
done
set +v

#echo "## Disabling foreman and puppetserver services, they'll be re-enabled by bootstrap init scripts"
#set -v -e
#systemctl disable puppetserver
#systemctl disable foreman
#systemctl disable foreman-proxy
#systemctl disable apache2

exit 0

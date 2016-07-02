#!/bin/bash

#echo "###### /root/.ssh/id_rsa.pub contents baked in:"
#cat /root/.ssh/id_rsa.pub

#rm -rf /etc/puppetlabs/ssl/*
#rm -rf /etc/puppetlabs/puppetdb/ssl/*

echo "## Generated Hiera files awaiting implementation by bsl_bootstrap init script:"

set -v
cat /etc/puppetlabs/code/bsl_bootstrap/hiera.yaml

cat /etc/puppetlabs/code/bsl_bootstrap/hieradata/puppetmaster.yaml

exit 0

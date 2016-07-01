#!/usr/bin/env bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build vagrant \
    --name=ubuntu-xenial64-puppetserver \
    --template=ubuntu/xenial64 \
    --provider=vmware \
    --puppetserver --bootstrap

#bitswarmbox build aws \
#    --name=ubuntu-xenial64-puppetserver \
#    --description='Puppetmaster Base' \
#    --aws_region=us-west-1 \
#    --aws_source_ami=ami-08490c68 \
#    --template='ubuntu/trusty64' \
#    --puppetserver --bootstrap

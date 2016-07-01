#!/usr/bin/env bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build vagrant \
    --name=ubuntu-trusty64-puppetserver \
    --template=ubuntu/trusty64 \
    --provider=vmware \
    --puppetserver --bootstrap

#bitswarmbox build aws \
#    --name=ubuntu-trusty64-puppetserver \
#    --description='Puppetmaster Base' \
#    --aws_region=us-west-1 \
#    --aws_source_ami=ami-48286c28 \
#    --template='ubuntu/trusty64' \
#    --puppetserver --bootstrap

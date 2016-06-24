#!/usr/bin/env bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build aws \
    --name="bitswarm-puppetmaster-ubuntu-xenial64-hvm-ebs-ssd" \
    --template="ubuntu/trusty64" \
    --description="Bitswarm Puppetmaster bootstrap running Ubuntu Xenial 16.04 LTS amd64 hvm:ebs-ssd" \
    --aws_region="us-west-1" \
    --aws_source_ami="ami-08490c68" \
    --puppetserver --bootstrap

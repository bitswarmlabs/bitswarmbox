#!/usr/bin/env bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build aws \
    --name="bitswarm-puppetmaster-ubuntu-trusty64-hvm-ebs-ssd" \
    --template="ubuntu/trusty64" \
    --description="Bitswarm Puppetmaster bootstrap running Ubuntu Trusty 14.04 LTS amd64 hvm:ebs-ssd" \
    --aws_region="us-west-1" \
    --aws_source_ami="ami-11286c71" \
    --puppetserver --bootstrap

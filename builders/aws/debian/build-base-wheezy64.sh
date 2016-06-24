#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build aws \
    --name="bitswarm-base-debian-wheezy64" \
    --template="debian/wheezy64" \
    --description="Bitswarm base image bootstrap running Debian Jessie amd64" \
    --aws_region="us-west-1" \
    --aws_source_ami="ami-b4869ff1" \
    --puppet --bootstrap

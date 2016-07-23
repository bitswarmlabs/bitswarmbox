#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build aws \
    --name="bitswarm-base-debian-jessie64" \
    --template="debian/jessie64" \
    --description="Bitswarm base image bootstrap running Debian Jessie amd64" \
    --aws_region="us-west-1" \
    --aws_source_ami="ami-45374b25" \
    --puppet --bootstrap

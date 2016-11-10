#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build aws \
    --name="foreman-debian-jessie64" \
    --template="debian/jessie64" \
    --description="Foreman bootstrap running Debian Jessie amd64" \
    --aws_region="us-east-1" \
    --aws_source_ami="ami-c8bda8a2" \
    --foreman --bootstrap

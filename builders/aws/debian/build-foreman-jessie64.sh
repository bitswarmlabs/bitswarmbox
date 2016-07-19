#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build aws \
    --name="bitswarm-foreman-debian-jessie64" \
    --template="debian/jessie64" \
    --description="Bitswarm Foreman bootstrap running Debian Jessie amd64" \
    --aws_region="us-west-1" \
    --aws_source_ami="ami-45374b25" \
    --foreman --foreman-admin-username=admin --foreman-admin-password=admin \
    --bootstrap

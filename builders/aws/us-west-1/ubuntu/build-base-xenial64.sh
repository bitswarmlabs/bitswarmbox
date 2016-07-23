#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build aws \
    --name="bitswarm-base-ubuntu-xenial64-hvm-ebs-ssd" \
    --template="ubuntu/xenial64" \
    --description="Bitswarm base image bootstrap running Ubuntu Xenial 16.04 LTS amd64 hvm:ebs-ssd" \
    --aws_region="us-west-1" \
    --aws_source_ami="ami-08490c68" \
    --puppet --bootstrap

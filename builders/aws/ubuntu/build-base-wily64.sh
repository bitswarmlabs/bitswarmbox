#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build aws \
    --name="bitswarm-base-ubuntu-wily64-hvm-ebs-ssd" \
    --template="ubuntu/wily64" \
    --description="Bitswarm base image bootstrap running Ubuntu Wily 15.10 amd64 hvm:ebs-ssd" \
    --aws_region="us-west-1" \
    --aws_source_ami="ami-3ac4be5a" \
    --puppet --bootstrap

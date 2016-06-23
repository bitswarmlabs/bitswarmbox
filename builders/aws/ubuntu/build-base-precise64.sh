#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build aws \
    --name="bitswarm-base-ubuntu-precise64-hvm-ebs-ssd" \
    --template="ubuntu/precise64" \
    --description="Bitswarm base image bootstrap running Ubuntu Precise 12.04 LTS amd64 hvm:ebs-ssd" \
    --aws_region="us-west-1" \
    --aws_source_ami="ami-bc0e4bdc" \
    --puppet --bootstrap

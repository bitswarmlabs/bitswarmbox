#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build aws \
    --name="bastion-centos7" \
    --template="centos/centos72.erb" \
    --description="Centos7 Bastion server amd64 hvm" \
    --aws_region="us-east-1" \
    --aws_source_ami="ami-6d1c2007" \
    --app_project="bastion" \
    --puppet --bootstrap

#!/usr/bin/env bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build vagrant \
    --name=ubuntu-trusty64-puppetserver \
    --template=ubuntu/trusty64 \
    --provider=virtualbox \
    --puppetserver

bitswarmbox build aws \
    --name="ubuntu-trusty64-puppetserver" \
    --description="Puppetmaster Base" \
    --aws_access_key=$AWS_ACCESS_KEY \
    --aws_secret_key=$AWS_SECRET_KEY \
    --aws_region="us-west-1" \
    --aws_source_ami="ami-48286c28" \
    --template="ubuntu/trusty64" \
    --puppetserver

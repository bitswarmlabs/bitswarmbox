#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build vagrant \
    --name=ubuntu-xenial64-base \
    --template=ubuntu/xenial64 \
    --provider=vmware \
    --puppet --bootstrap

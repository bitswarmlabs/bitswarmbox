#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build vagrant \
    --name=ubuntu-trusty64-base \
    --template=ubuntu/trusty64 \
    --provider=vmware \
    --puppet --bootstrap

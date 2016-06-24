#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build vagrant \
    --name=ubuntu-wily64-base \
    --template=ubuntu/wily64 \
    --provider=virtualbox \
    --puppet --bootstrap

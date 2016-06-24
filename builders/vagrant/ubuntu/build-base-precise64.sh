#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build vagrant \
    --name=ubuntu-precise64-base \
    --template=ubuntu/precise64 \
    --provider=virtualbox \
    --puppet --bootstrap

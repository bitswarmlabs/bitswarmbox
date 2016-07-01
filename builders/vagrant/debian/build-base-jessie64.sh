#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build vagrant \
    --name="base-debian-jessie" \
    --template="debian/jessie64" \
    --provider="vmware" \
    --puppet --bootstrap

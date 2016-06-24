#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build vagrant \
    --name="base-debian-wheezy" \
    --template="debian/wheezy64" \
    --provider="virtualbox" \
    --puppet --bootstrap

#!/bin/bash

which bitswarmbox || gem install bitswarmbox

bitswarmbox build vagrant \
    --name="puppetserver-debian-jessie" \
    --template="debian/jessie64" \
    --provider="virtualbox" \
    --puppetserver --bootstrap

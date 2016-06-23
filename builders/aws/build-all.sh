#!/bin/bash

echo "Building all AWS base AMIs..."

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "${DIR}/../../"
echo " - Using context root $(pwd)"

set -ex

$DIR/debian/build-base-jessie64.sh
$DIR/debian/build-base-wheezy64.sh
$DIR/ubuntu/build-base-precise64.sh
$DIR/ubuntu/build-base-trusty64.sh
$DIR/ubuntu/build-base-wily64.sh
$DIR/ubuntu/build-base-xenial64.sh

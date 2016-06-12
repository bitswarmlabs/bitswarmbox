#!/bin/sh

set -e

rm -rf json
mkdir -p json

if [ -e `which greadlink` ]; then
  basedir=$(dirname $(greadlink -f $0))
else
  basedir=$(dirname $(readlink -f $0))
fi

for d in $(find ./templates -type d); do
  for f in $(find $d -name '*.erb'); do
    template_name=$(echo $f | rev | cut -d"/" -f1 | rev | cut -d"." -f1)
    template_path=$(dirname $f)
    if [ -e `which greadlink` ]; then
      template_dir=$(dirname $(greadlink -f $f))
      template_full_path=$(greadlink -f $f)
    else
      template_dir=$(dirname $(readlink -f $f))
      template_full_path=$(readlink -f $f)
    fi
    ln -sfv ${template_full_path} ${basedir}/json/${template_name}-erb.json
  done
done

echo "Created links as json for each template found"

exit

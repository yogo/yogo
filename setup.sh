#!/bin/bash

pushd `dirname $0`

RUBY="ruby -X-C -S"
echo "Configuring fresh yogo checkout for development..."
git submodule init && \
git submodule update && \
$RUBY gem install bundler && \
$RUBY gem bundle && \
$RUBY bin/rake yogo:setup NO_PERSEVERE=true && \
$RUBY bin/rake db:seed NO_PERSEVERE=true

popd
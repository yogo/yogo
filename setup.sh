#!/bin/bash

RUBY_VERSION=`/usr/bin/env ruby -v | awk '{print $1}'`

if [ $RUBY_VERSION == "jruby" ]
then
  RUBY="ruby -X-C -S"
else
  RUBY="ruby -S"
fi

pushd `dirname $0`


echo "Configuring fresh yogo checkout for development..."
git submodule init && \
git submodule update && \

$RUBY gem install bundler -v 0.8.1 && \
$RUBY gem install rake && \
$RUBY gem bundle && \

$RUBY rake persvr:setup && \
$RUBY rake yogo:setup && \
$RUBY rake db:seed NO_PERSEVERE=true

popd
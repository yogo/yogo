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

$RUBY gem install bundler && \
$RUBY gem install rake && \
$RUBY gem install mongrel && \

$RUBY bundle install && \
$RUBY rake persvr:setup

popd
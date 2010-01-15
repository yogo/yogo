#!/bin/bash

RUBY="ruby -X-C -S"
echo "Configuring fresh yogo checkout for development..."
git submodule init && \
git submodule update && \
$RUBY gem install bundler && \
$RUBY gem bundle && \
$RUBY rake yogo:setup NO_PERSEVERE=true && \
$RUBY rake db:seed NO_PERSEVERE=true
#!/bin/bash

pushd `dirname $0`

cd yogo

rake yogo:stop

popd

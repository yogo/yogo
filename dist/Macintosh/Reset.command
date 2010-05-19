#!/bin/bash

pushd `dirname $0`

if [ -d yogo ]
  then
  cd yogo
  
  rake yogo:clean
fi

popd 

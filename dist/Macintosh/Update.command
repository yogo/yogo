#!/bin/bash

pushd `dirname $0`

if [ ! -d yogo ]
  then
  
  git clone git://github.com/yogo/yogo.git

  cd yogo
  
  ./setup.sh
  
else
  cd yogo

  rake yogo:update
fi

popd
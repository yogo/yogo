#!/bin/bash

pushd `dirname $0`

if [ ! -d yogo ]
  then
  
  git clone git://github.com/yogo/yogo.git

  cd yogo
  
  ./setup.sh
  
else
  cd yogo
  
  git clean -f -q

  git pull

  ./setup.sh
  
fi

popd
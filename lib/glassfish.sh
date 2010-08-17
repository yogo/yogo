#!/bin/bash

# Adding RVM configuration for users in the RVM group
# . "/usr/local/rvm/scripts/rvm"
#
# rvm use jruby

RAILS_APP=/home/voeis-demo/voeis/current

case "$1" in
start)
  echo "Starting glassfish"
  cd $RAILS_APP
  nohup jruby --server -X-C -S glassfish
;;
restart)
  $0 stop
  $0 start
;;
stop)
  echo "Stopping glassfish"
  cd $RAILS_APP
  for i in `ls ~/voeis/shared/pids/glassfish*.pid`
  do
    pid=`cat $i`
    kill -s2 $pid
  done

;;
*)
  echo ”usage: $0  start|stop|restart”
  exit 3
;;
esac

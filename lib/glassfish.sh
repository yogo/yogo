#!/bin/bash
#

RAILS_APP=/home/voeis-demo/voeis/current

case "$1" in
start)
  echo "Starting glassfish"
  cd $RAILS_APP
  jruby --server -X-C -S glassfish -d -P ~/voeis/shared/pids/glassfish.pid
;;
restart)
  $0 stop
  $0 start
;;
stop)
  echo "Stopping glassfish"
  cd $RAILS_APP
  kill -s2 `cat ~/voeis/shared/pids/glassfish.pid`

;;
*)
  echo ”usage: $0  start|stop|restart”
  exit 3
;;
esac

#!/bin/sh

JRUBYBIN=/opt/jruby/bin
RAILS_APP=/home/voeis-demo/rails/voeis-demo/current
PATH=$JRUBYBIN:$PATH

case "$1" in
start)
  echo "Starting glassfish"
  cd $RAILS_APP
  nohup $JRUBYBIN/jruby --server -X-C -S glassfish
;;
restart)
  $0 stop
  $0 start
;;
stop)
  echo "Stopping glassfish"
  cd $RAILS_APP
  for i in `ls ~/rails/voeis-demo/shared/pids/glassfish*.pid`
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

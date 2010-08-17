#!/bin/bash
#

RAILS_APP=/home/voeis-demo/voeis/current

case "$1" in
  start)
    echo "Starting glassfish"
    cd $RAILS_APP
    glassfish -d -P $RAILS_APP/../shared/pids/glassfish.pid
  ;;

  restart)
    $0 stop
    $0 start
  ;;

  stop)
    echo "Stopping glassfish"
    cd $RAILS_APP
    kill -s2 `cat $RAILS_APP/../shared/pids/glassfish.pid`

  ;;

  *)
    echo ”usage: $0  start|stop|restart”
    exit 3
  ;;
esac

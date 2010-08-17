#!/bin/bash
#

RAILS_APP=/home/voeis-demo/voeis/current
export CLASSPATH=$RAILS_APP/lib/jna.jar

case "$1" in
  start)
    echo "Starting glassfish"
    cd $RAILS_APP
    glassfish
  ;;

  restart)
    $0 stop
    $0 start
  ;;

  stop)
    echo "Stopping glassfish"
    cd $RAILS_APP
    kill -s 2 `cat $RAILS_APP/../shared/pids/glassfish.pid`

  ;;

  *)
    echo ”usage: $0  start|stop|restart”
    exit 3
  ;;
esac

#!/bin/bash
#

RAILS_APP=/home/voeis-demo/voeis/current
export CLASSPATH=$RAILS_APP/lib/jna.jar

case "$1" in
  start)
    echo "Starting glassfish"
    cd $RAILS_APP
    glassfish -P $RAILS_APP/../shared/pids/glassfish.pid
  ;;

  restart)
    $0 stop
    $0 start
  ;;

  stop)
    echo "Stopping glassfish"
    cd $RAILS_APP
    if [ -f $RAILS_APP/../shared/pids/glassfish.pid ]; then
      kill -2 `cat $RAILS_APP/../shared/pids/glassfish.pid`
    fi
  ;;

  *)
    echo ”usage: $0  start|stop|restart”
    exit 3
  ;;
esac

#!/bin/bash -x
#

RAILS_APP=/home/voeis-demo/voeis/current
PIDFILE=/home/voeis-demo/voeis/shared/pids/glassfish.pid

export CLASSPATH=$RAILS_APP/lib/jna.jar

case "$1" in
  start)
    echo "Starting glassfish"
    cd $RAILS_APP
    jruby -X-C -S glassfish -P $PIDFILE
  ;;

  restart)
    $0 stop
    $0 start
  ;;

  stop)
    echo "Stopping glassfish"
    cd $RAILS_APP
    if [ -f $PIDFILE ]; then
      kill -2 `cat $PIDFILE`
    fi
  ;;

  *)
    echo ”usage: $0  start|stop|restart”
    exit 3
  ;;
esac

#!/bin/bash
#

RAILS_APP=/home/voeis-demo/voeis/current
PIDFILE=/home/voeis-demo/voeis/shared/pids/trinidad.pid

case "$1" in
  start)
    echo "Starting trinidad"
    cd $RAILS_APP
    nohup trinidad --config > $RAILS_APP/log/trinidad.log 2>&1 &
    rm $PIDFILE
    echo $! > $PIDFILE
  ;;

  restart)
    $0 stop
    $0 start
  ;;

  stop)
    echo "Stopping trinidad"
    cd $RAILS_APP
    if [ -f $PIDFILE ]; then
      kill -2 `cat $PIDFILE`
      if [ "x$!" == "x0" ]; then
        rm $PIDFILE
      else
        echo "Failed to kill trinidad"
      fi
    fi
  ;;

  *)
    echo ”usage: $0  start|stop|restart”
    exit 3
  ;;
esac

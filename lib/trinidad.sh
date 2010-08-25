#!/bin/bash
#

RAILS_APP=/home/voeis-demo/voeis/current
PIDFILE=/home/voeis-demo/voeis/shared/pids/trinidad.pid

case "$1" in
  start)
    echo "Starting trinidad"
    cd $RAILS_APP
    nohup trinidad --config > $RAILS_APP/log/trinidad.log 2>&1 &
    if [ $! != $$ ]; then
      rm $PIDFILE
      echo $! > $PIDFILE
    else
      echo "Failed to start trinidad, it appears to already be running."
    fi
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
      if [ $! == 0 ]; then
        rm $PIDFILE
      else
        echo "Failed to kill trinidad, resorting to brute force."
        # Find the darn thing and kill it
        TPID="`ps auwx | grep trinidad | grep -v grep | awk '{ print $2 }'`"
        kill -9 $TPID
      fi
    fi
  ;;

  *)
    echo ”usage: $0  start|stop|restart”
    exit 3
  ;;
esac

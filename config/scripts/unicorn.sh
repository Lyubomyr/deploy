#!/bin/bash
# set -u
# set -e
# Example init script, this can be used with nginx, too,
# since nginx and unicorn accept the same signals

# Feel free to change any of the following variables for your app:

ENV=fetch(:staging)
USER=fetch(:user)
USER_HOME=fetch(:user_home_path)
APP_ROOT=$USER_HOME/current
PID=$USER_HOME/shared/tmp/pids/unicorn.pid
old_pid="$PID.oldbin"

GEM_HOME="/app/shared/bundle/ruby/2.1.0/gems"
RUBY_BIN="/home/ubuntu/.rbenv/shims"

SET_PATH="PATH=$RUBY_BIN:$GEM_HOME/bin:$PATH; export GEM_HOME=$GEM_HOME"
UNICORN_OPTS="-D -E $ENV -c $APP_ROOT/config/unicorn/production.rb"

CMD="$SET_PATH; cd $APP_ROOT && bin/bundle exec unicorn $UNICORN_OPTS"
echo $CMD
cd $APP_ROOT || exit 1


sig () {
  test -s "$PID" && su $USER -c "kill -$1 `cat $PID`"
}

oldsig () {
  test -s $old_pid && su $USER -c "kill -$1 `cat $old_pid`"
}

workersig () {
  workerpid="$USER_HOME/shared/tmp/pids/.$2.pid"

  test -s "$workerpid" && su $USER -c "kill -$1 `cat $workerpid`"
}

case $1 in
start)
  sig 0 && echo >&2 "Already running" && exit 0
  su $USER -c "$CMD"
  ;;
stop)
  sig QUIT && exit 0
  echo >&2 "Not running"
  ;;
force-stop)
  sig TERM && exit 0
  echo >&2 "Not running"
  ;;
restart|reload)
  sig HUP && echo reloaded OK && exit 0
  echo >&2 "Couldn't reload, starting '$CMD' instead"
  $CMD
  ;;
upgrade)
  sig USR2 && exit 0
  echo >&2 "Couldn't upgrade, starting '$CMD' instead"
  $CMD
  ;;
kill_worker)
  workersig QUIT $2 && exit 0
  echo >&2 "Worker not running"
  ;;
rotate)
        sig USR1 && echo rotated logs OK && exit 0
        echo >&2 "Couldn't rotate logs" && exit 1
        ;;
*)
  echo >&2 "Usage: $0 <start|stop|restart|upgrade|rotate|force-stop>"
  exit 1
  ;;
esac

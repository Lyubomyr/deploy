#!/bin/bash
# upstart-job
#
# Symlink target for initscripts that have been converted to Upstart.
set -e

ENV=production
USER=ubuntu
APP_ROOT="/app/current"
GEM_HOME="/app/shared/bundle/ruby/2.1.0/gems"
RUBY_BIN="#{fetch(:rvm_home_path)}/rubies/ruby-#{fetch(:rvm1_ruby_version)}/bin"

SET_PATH="PATH=$RUBY_BIN:$GEM_HOME/bin:$PATH; export GEM_HOME=$GEM_HOME"

start_job() {
        echo "Starting delayed job"
        su $USER -c "$SET_PATH; cd $APP_ROOT && /usr/bin/env RAILS_ENV=$ENV bin/delayed_job start"
}

stop_job() {
        echo "Stopping delayed job"
        su $USER -c "$SET_PATH; cd $APP_ROOT && /usr/bin/env RAILS_ENV=$ENV bin/delayed_job stop"

}

COMMAND="$1"
shift

case $COMMAND in
status)
    ;;
start|stop|restart)
    $ECHO
    if [ "$COMMAND" = "stop" ]; then
        stop_job
    elif [ "$COMMAND" = "start" ]; then
        start_job
    elif  [ "$COMMAND" = "restart" ]; then
        stop_job
        sleep 1s
        start_job
        exit 0
    fi
    ;;
esac

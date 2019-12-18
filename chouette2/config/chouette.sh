#!/bin/bash

CHOUETTE_HOME=`dirname $0`/..
source $CHOUETTE_HOME/.bashrc
source $CHOUETTE_HOME/.profile

cd $CHOUETTE_HOME/chouette2/

export RAILS_ENV=production

echo "Remove old PID file..."
rm -f tmp/pids/server.pid

echo "Chouette init postgis..."
bin/rake db:gis:setup

echo "Chouette migrate..."
bin/rake db:migrate

bin/rake assets:precompile

echo "Chouette Ruby starting..."
bin/rails s -b 0.0.0.0 -p 3000


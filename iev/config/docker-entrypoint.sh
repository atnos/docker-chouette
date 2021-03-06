#!/bin/bash

INIT_FILE="/opt/jboss/initialized.done"

function waitWildfly {
	status=""
	while [ "$status" != "running" ];do
		status=$(/opt/wildfly/bin/jboss-cli.sh -c --user=admin --password=admin --commands="read-attribute server-state")
		if [ "$status" != "running" ]; then
			echo "Waiting for Wildfly..."
			sleep 1
		fi
	done
}

function initWildfly {
	waitWildfly
	/opt/wildfly/bin/jboss-cli.sh -c --user=admin --password=admin --file=/tmp/wildfly-datasources.cli
	/opt/wildfly/bin/jboss-cli.sh -c --user=admin --password=admin --command="/:reload"
	# cd /tmp/chouette && mvn -DskipTests install
	/opt/wildfly/bin/jboss-cli.sh -c --user=admin --password=admin --command="deploy /tmp/chouette.ear"
	touch $INIT_FILE
}

function waitPostgres {
  status="closed"
  while [[ $status == *"closed"* ]];do
    status=$(nmap -v -p 5432 chouette-postgres)
    echo 'Waiting for Postgres...'
    sleep 2
  done
  exec "$@"
}

[ ! -e $INIT_FILE ] && initWildfly &

waitPostgres "$@"


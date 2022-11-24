#!/bin/bash
echo $(date +"%Y/%m/%d %T") "Executing sql-runner... "

export DB_USER=openline
export DB_PWD=m4C7DbyHdyntt2Hq
export DB_HOST=host.docker.internal
export DB_PORT=5435
export DB_NAME=snowplow

./run_config.sh -b ./sql-runner-linux \
-c web/v1/postgres/configs/datamodeling.json \
-t ./templates/postgres.yml.tmpl \
-v ./templates/variables.yml.tmpl;

echo $(date +"%Y/%m/%d %T") "sql-runner completed"
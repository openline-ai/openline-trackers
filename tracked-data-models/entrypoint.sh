#!/bin/bash
echo $(date +"%Y/%m/%d %T") "Executing sql-runner... "


./run_config.sh -b ./sql-runner-linux \
-c web/v1/postgres/configs/datamodeling.json \
-t ./templates/postgres.yml.tmpl \
-v ./templates/variables.yml.tmpl;

echo $(date +"%Y/%m/%d %T") "sql-runner completed"
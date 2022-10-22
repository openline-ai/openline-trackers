# tracked-data-models

These models are written in a format that is runnable via [SQL-runner](https://github.com/snowplow/sql-runner)

## Prerequisites
Following environment variables are required to be provided for postgres DB connection:
* `DB_USER`
* `DB_PWD`
* `DB_HOST`
* `DB_PORT`

## Running models
### Local
For local run, use `run.sh` script for single execution.

### Production
Use latest [docker image](https://github.com/openline-ai/openline-trackers/pkgs/container/openline-trackers%2Ftracked-data-models).
For continuous data modeling set-up a cron job that will trigger app in docker container.
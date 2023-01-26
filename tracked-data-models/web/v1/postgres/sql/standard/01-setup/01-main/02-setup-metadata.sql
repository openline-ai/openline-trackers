CREATE SEQUENCE IF NOT EXISTS {{.output_schema}}.shared_id_seq START 1;

-- Table for trackers configurations
CREATE TABLE IF NOT EXISTS {{.tenant_schema}}.{{.tracker_table}} (
    id serial primary key,
    tenant varchar(64) not null,
    tracker_name varchar(255) not null unique,
    app_id varchar(128) not null
);

-- A table storing an identifier for this run of a model - used to identify runs of the model across multiple modules/steps (eg. base, page views share this id per run)
CREATE TABLE IF NOT EXISTS {{.scratch_schema}}.metadata_run_id{{.entropy}} (
    run_id TIMESTAMP
);

-- set the timestamp identifier used to identify runs of the model across multiple modules/steps
TRUNCATE {{.scratch_schema}}.metadata_run_id{{.entropy}};

INSERT INTO {{.scratch_schema}}.metadata_run_id{{.entropy}} values (now());

-- Permanent metadata table
CREATE TABLE IF NOT EXISTS {{.output_schema}}.datamodel_metadata{{.entropy}} (
  run_id TIMESTAMP,
  model_version VARCHAR(64),
  model VARCHAR(64),
  module VARCHAR(64),
  run_start_tstamp TIMESTAMP,
  run_end_tstamp TIMESTAMP,
  rows_this_run INT,
  distinct_key VARCHAR(64),
  distinct_key_count INT,
  time_key VARCHAR(64),
  min_time_key TIMESTAMP,
  max_time_key TIMESTAMP,
  duplicate_rows_removed INT,
  distinct_keys_removed INT
);

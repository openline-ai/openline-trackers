-- app_info table
CREATE TABLE IF NOT EXISTS {{.output_schema}}.app_info{{.entropy}} (
    id           bigint,
    tenant       varchar(64),
    name_tracker varchar(128),
    app_id       varchar(255),
    platform     varchar(255),
    updated_on   timestamp
);


-- page_info table
CREATE TABLE IF NOT EXISTS {{.output_schema}}.page_info{{.entropy}} (
    tenant       varchar(64),
    name_tracker varchar(128),
    app_id       varchar(255),
    page_url     varchar(4096),
    page_title   varchar(2000),
    updated_on   timestamp,
    row_number   bigint,
    id           bigint
);


-- A table storing last successful run per scope
CREATE TABLE IF NOT EXISTS {{.output_schema}}.info_last_success_run_id{{.entropy}} (
    run_id TIMESTAMP
);

insert into {{.output_schema}}.info_last_success_run_id{{.entropy}} (select '{{.start_date}}' where
    (select run_id from {{.output_schema}}.info_last_success_run_id{{.entropy}}) is null);


-- Setup temp metadata tables for this run
CREATE TABLE IF NOT EXISTS {{.scratch_schema}}.info_metadata_this_run{{.entropy}} (
    id VARCHAR(64),
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

TRUNCATE {{.scratch_schema}}.info_metadata_this_run{{.entropy}};

INSERT INTO {{.scratch_schema}}.info_metadata_this_run{{.entropy}} (
    SELECT
    'run',
    run_id,
    '{{.model_version}}',
    'info',
    'main',
    now(),
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
    FROM {{.scratch_schema}}.metadata_run_id{{.entropy}}
    );
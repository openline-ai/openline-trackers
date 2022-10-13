-- A table storing last successful run per scope
CREATE TABLE IF NOT EXISTS {{.output_schema}}.users_last_success_run_id{{.entropy}} (
    run_id TIMESTAMP
);

insert into {{.output_schema}}.users_last_success_run_id{{.entropy}} (select '{{.start_date}}' where
    (select run_id from {{.output_schema}}.users_last_success_run_id{{.entropy}}) is null);

-- Setup Metadata
DROP TABLE IF EXISTS {{.scratch_schema}}.users_metadata_this_run{{.entropy}};

CREATE TABLE {{.scratch_schema}}.users_metadata_this_run{{.entropy}} (
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

INSERT INTO {{.scratch_schema}}.users_metadata_this_run{{.entropy}} (
  SELECT
    'run',
    run_id,
    '{{.model_version}}',
    'users',
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


CREATE TABLE IF NOT EXISTS {{.output_schema}}.users{{.entropy}} (
  -- app ID
  app_id VARCHAR(255),
  name_tracker varchar(128),
  tenant varchar(64),

  -- user fields
  user_id VARCHAR(255) ,
  domain_userid VARCHAR(128) ,
  network_userid VARCHAR(128) ,

  start_tstamp TIMESTAMP,
  end_tstamp TIMESTAMP ,

  page_views INT ,

  sessions INT ,

  engaged_time_in_s INT ,

  -- first page fields
  first_page_title VARCHAR(2000) ,

  first_page_url VARCHAR(4096) ,

  first_page_urlscheme VARCHAR(16) ,
  first_page_urlhost VARCHAR(255) ,
  first_page_urlpath VARCHAR(3000) ,
  first_page_urlquery VARCHAR(6000) ,
  first_page_urlfragment VARCHAR(3000) ,

  last_page_title VARCHAR(2000) ,

  last_page_url VARCHAR(4096) ,

  last_page_urlscheme VARCHAR(16) ,
  last_page_urlhost VARCHAR(255) ,
  last_page_urlpath VARCHAR(3000) ,
  last_page_urlquery VARCHAR(6000) ,
  last_page_urlfragment VARCHAR(3000) ,

  -- referrer fields
  referrer VARCHAR(4096) ,

  refr_urlscheme VARCHAR(16) ,
  refr_urlhost VARCHAR(255) ,
  refr_urlpath VARCHAR(6000) ,
  refr_urlquery VARCHAR(6000) ,
  refr_urlfragment VARCHAR(3000) ,

  refr_medium VARCHAR(25) ,
  refr_source VARCHAR(50) ,
  refr_term VARCHAR(255) ,

  -- marketing fields
  mkt_medium VARCHAR(255) ,
  mkt_source VARCHAR(255) ,
  mkt_term VARCHAR(255) ,
  mkt_content VARCHAR(500) ,
  mkt_campaign VARCHAR(255) ,
  mkt_clickid VARCHAR(128) ,
  mkt_network VARCHAR(64)
);

CREATE TABLE IF NOT EXISTS {{.output_schema}}.users_manifest{{.entropy}} (
    domain_userid VARCHAR(128),
    start_tstamp TIMESTAMP
);
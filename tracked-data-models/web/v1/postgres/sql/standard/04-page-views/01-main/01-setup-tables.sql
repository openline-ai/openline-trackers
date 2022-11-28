-- A table storing last successful run per scope
CREATE TABLE IF NOT EXISTS {{.output_schema}}.pv_last_success_run_id{{.entropy}} (
    run_id TIMESTAMP
);

insert into {{.output_schema}}.pv_last_success_run_id{{.entropy}} (select '{{.start_date}}' where
    (select run_id from {{.output_schema}}.pv_last_success_run_id{{.entropy}}) is null);


-- Setup temp metadata tables for this run
CREATE TABLE IF NOT EXISTS {{.scratch_schema}}.pv_metadata_this_run{{.entropy}} (
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

TRUNCATE {{.scratch_schema}}.pv_metadata_this_run{{.entropy}};

INSERT INTO {{.scratch_schema}}.pv_metadata_this_run{{.entropy}} (
    SELECT
    'run',
    run_id,
    '{{.model_version}}',
    'pageviews',
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

-- Create page views table if it doesn't exist
CREATE TABLE IF NOT EXISTS {{.output_schema}}.page_views{{.entropy}} (

  page_view_id CHAR(36)  NOT NULL,
  event_id CHAR(36) ,

  app_id VARCHAR(255) ,
  name_tracker varchar(128),
  tenant varchar(64),

  visitor_id VARCHAR(255) ,
  domain_userid VARCHAR(128) ,
  network_userid VARCHAR(128) ,

  domain_sessionid VARCHAR(128) ,
  domain_sessionidx INT,
  page_view_in_session_index INT ,
  page_views_in_session INT ,

  dvce_created_tstamp TIMESTAMP ,
  collector_tstamp TIMESTAMP ,
  derived_tstamp TIMESTAMP ,
  start_tstamp TIMESTAMP ,
  end_tstamp TIMESTAMP ,

  engaged_time_in_s INT ,

  horizontal_pixels_scrolled INT ,
  vertical_pixels_scrolled INT ,
  horizontal_percentage_scrolled DOUBLE PRECISION ,
  vertical_percentage_scrolled DOUBLE PRECISION ,

  doc_width INT ,
  doc_height INT ,

  page_title VARCHAR(2000) ,
  page_url VARCHAR(4096) ,
  page_urlscheme VARCHAR(16) ,
  page_urlhost VARCHAR(255) ,
  page_urlpath VARCHAR(3000) ,
  page_urlquery VARCHAR(6000) ,
  page_urlfragment VARCHAR(3000) ,

  mkt_medium VARCHAR(255) ,
  mkt_source VARCHAR(255) ,
  mkt_term VARCHAR(255) ,
  mkt_content VARCHAR(500) ,
  mkt_campaign VARCHAR(255) ,
  mkt_clickid VARCHAR(128) ,
  mkt_network VARCHAR(64) ,

  page_referrer VARCHAR(4096) ,
  refr_urlscheme  VARCHAR(16) ,
  refr_urlhost VARCHAR(255) ,
  refr_urlpath VARCHAR(6000) ,
  refr_urlquery VARCHAR(6000) ,
  refr_urlfragment VARCHAR(3000) ,
  refr_medium VARCHAR(25) ,
  refr_source VARCHAR(50) ,
  refr_term VARCHAR(255) ,

  geo_country CHAR(2) ,
  geo_region CHAR(3) ,
  geo_region_name VARCHAR(100) ,
  geo_city VARCHAR(75) ,
  geo_zipcode VARCHAR(15) ,
  geo_latitude DOUBLE PRECISION ,
  geo_longitude DOUBLE PRECISION ,
  geo_timezone  VARCHAR(64) ,

  user_ipaddress VARCHAR(128) ,

  useragent VARCHAR(1000) ,

  br_lang VARCHAR(255) ,
  br_viewwidth INT ,
  br_viewheight INT ,
  br_colordepth VARCHAR(12),
  br_renderengine VARCHAR(50),
  os_timezone VARCHAR(255),

  -- optional UA parser fields
  useragent_family VARCHAR,
  useragent_major VARCHAR,
  useragent_minor VARCHAR,
  useragent_patch VARCHAR,
  useragent_version VARCHAR,
  os_family VARCHAR,
  os_major VARCHAR,
  os_minor VARCHAR,
  os_patch VARCHAR,
  os_patch_minor VARCHAR,
  os_version VARCHAR,
  device_family VARCHAR,

  -- optional YAUAA fields
  device_class VARCHAR,
  agent_class VARCHAR,
  agent_name VARCHAR,
  agent_name_version VARCHAR,
  agent_name_version_major VARCHAR,
  agent_version VARCHAR,
  agent_version_major VARCHAR,
  device_brand VARCHAR,
  device_name VARCHAR,
  device_version VARCHAR,
  layout_engine_class VARCHAR,
  layout_engine_name VARCHAR,
  layout_engine_name_version VARCHAR,
  layout_engine_name_version_major VARCHAR,
  layout_engine_version VARCHAR,
  layout_engine_version_major VARCHAR,
  operating_system_class VARCHAR,
  operating_system_name VARCHAR,
  operating_system_name_version VARCHAR,
  operating_system_version VARCHAR,

  synced_to_customer_os BOOLEAN DEFAULT FALSE
);

-- Create staging table - acts as input to sessions step
CREATE TABLE IF NOT EXISTS {{.scratch_schema}}.page_views_staged{{.entropy}} (LIKE {{.output_schema}}.page_views{{.entropy}});

-- Setup Sessions table
CREATE TABLE IF NOT EXISTS {{.output_schema}}.sessions{{.entropy}} (
    -- app ID
    app_id VARCHAR(255),

    -- session fields
    domain_sessionid VARCHAR(128),
    domain_sessionidx INT,

    start_tstamp TIMESTAMP,
    end_tstamp TIMESTAMP,

    -- user fields
    user_id VARCHAR(255),
    domain_userid VARCHAR(128),
    network_userid VARCHAR(128),

    page_views INT,
    engaged_time_in_s INT,

    -- first page fields
    first_page_title VARCHAR(2000),

    first_page_url VARCHAR(4096),

    first_page_urlscheme VARCHAR(16),
    first_page_urlhost VARCHAR(255),
    first_page_urlpath VARCHAR(3000),
    first_page_urlquery VARCHAR(6000),
    first_page_urlfragment VARCHAR(3000),

    last_page_title VARCHAR(2000),

    last_page_url VARCHAR(4096),

    last_page_urlscheme VARCHAR(16),
    last_page_urlhost VARCHAR(255),
    last_page_urlpath VARCHAR(3000),
    last_page_urlquery VARCHAR(6000),
    last_page_urlfragment VARCHAR(3000),

    -- referrer fields
    referrer VARCHAR(4096),

    refr_urlscheme VARCHAR(16),
    refr_urlhost VARCHAR(255),
    refr_urlpath VARCHAR(6000),
    refr_urlquery VARCHAR(6000),
    refr_urlfragment VARCHAR(3000),

    refr_medium VARCHAR(25),
    refr_source VARCHAR(50),
    refr_term VARCHAR(255),

    -- marketing fields
    mkt_medium VARCHAR(255),
    mkt_source VARCHAR(255),
    mkt_term VARCHAR(255),
    mkt_content VARCHAR(500),
    mkt_campaign VARCHAR(255),
    mkt_clickid VARCHAR(128),
    mkt_network VARCHAR(64),

    -- geo fields
    geo_country CHAR(2),
    geo_region CHAR(3),
    geo_region_name VARCHAR(100),
    geo_city VARCHAR(75),
    geo_zipcode VARCHAR(15),
    geo_latitude DOUBLE PRECISION,
    geo_longitude DOUBLE PRECISION,
    geo_timezone VARCHAR(64),

    -- IP address
    user_ipaddress VARCHAR(128),

    -- user agent
    useragent VARCHAR(1000),

    br_renderengine VARCHAR(50),
    br_lang VARCHAR(255),

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
    operating_system_version VARCHAR
);

-- Staged manifest table as input to users step
CREATE TABLE IF NOT EXISTS {{.scratch_schema}}.sessions_userid_manifest_staged{{.entropy}} (
    domain_userid VARCHAR(128),
    start_tstamp TIMESTAMP
);

-- A table storing last successful run per scope
CREATE TABLE IF NOT EXISTS {{.output_schema}}.sessions_last_success_run_id{{.entropy}} (
    run_id TIMESTAMP
);

insert into {{.output_schema}}.sessions_last_success_run_id{{.entropy}} (select '{{.start_date}}' where
    (select run_id from {{.output_schema}}.sessions_last_success_run_id{{.entropy}}) is null);


-- Setup temp metadata tables for this run
CREATE TABLE IF NOT EXISTS {{.scratch_schema}}.sessions_metadata_this_run{{.entropy}} (
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

TRUNCATE {{.scratch_schema}}.sessions_metadata_this_run{{.entropy}};

INSERT INTO {{.scratch_schema}}.sessions_metadata_this_run{{.entropy}} (
    SELECT
    'run',
    run_id,
    '{{.model_version}}',
    'sessions',
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
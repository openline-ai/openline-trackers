DROP TABLE IF EXISTS {{.scratch_schema}}.pv_ids_lookback{{.entropy}};

CREATE TABLE {{.scratch_schema}}.pv_ids_lookback{{.entropy}}
as (
    select distinct(id) from {{.input_schema}}.com_snowplowanalytics_snowplow_web_page_1 a
    where
    a.root_tstamp >= (select max(run_id) + INTERVAL '-{{.look_back_days}} day'  from {{.output_schema}}.pv_last_success_run_id{{.entropy}})
    and a.root_tstamp <= (select max(run_id) from {{.scratch_schema}}.metadata_run_id{{.entropy}})
);

-- -----------
DROP TABLE IF EXISTS {{.scratch_schema}}.pv_events_lookback{{.entropy}};

CREATE TABLE {{.scratch_schema}}.pv_events_lookback{{.entropy}}
AS (
       SELECT
       a.*,
       b.id AS page_view_id
       FROM
    {{.input_schema}}.events a
       INNER JOIN
    {{.input_schema}}.com_snowplowanalytics_snowplow_web_page_1 b
       ON a.event_id = b.root_id
       AND a.collector_tstamp = b.root_tstamp
       INNER JOIN
    {{.tenant_schema}}.{{.tracker_table}} c on c.tracker_name = a.name_tracker and c.app_id = a.app_id
       INNER JOIN
    {{.scratch_schema}}.pv_ids_lookback{{.entropy}} d on d.id = b.id
       where a.event in ('page_view','page_ping')
    );

-- ------
DROP TABLE IF EXISTS {{.scratch_schema}}.pv_page_view_events_lookback{{.entropy}};

CREATE TABLE {{.scratch_schema}}.pv_page_view_events_lookback{{.entropy}}
AS(
      SELECT

      ev.page_view_id as page_view_id_lookback,
      ev.event_id as event_id_lookback,

      ROW_NUMBER() OVER (PARTITION BY ev.domain_sessionid ORDER BY ev.derived_tstamp) AS page_view_in_session_index_lookback
    FROM {{.scratch_schema}}.pv_events_lookback{{.entropy}} AS ev
    WHERE ev.event_name = 'page_view'
    AND ev.page_view_id IS NOT NULL
);

-- update page_view_in_session_index with correct value including previous page views
update {{.scratch_schema}}.pv_page_view_events{{.entropy}}
    set page_view_in_session_index = page_view_in_session_index_lookback
    from {{.scratch_schema}}.pv_page_view_events_lookback{{.entropy}}
         where page_view_id = page_view_id_lookback and event_id = event_id_lookback;
-- Staged pave view IDs
DROP TABLE IF EXISTS {{.scratch_schema}}.pv_ids_staged{{.entropy}};

CREATE TABLE {{.scratch_schema}}.pv_ids_staged{{.entropy}}
as (
    select distinct(id) from {{.input_schema}}.com_snowplowanalytics_snowplow_web_page_1 a
    where
        a.root_tstamp >= (select max(run_id) from {{.output_schema}}.pv_last_success_run_id{{.entropy}})
    and a.root_tstamp <= (select max(run_id) from {{.scratch_schema}}.metadata_run_id{{.entropy}})
);


-- Events corresponding to staged page view IDs
DROP TABLE IF EXISTS {{.scratch_schema}}.pv_events_staged{{.entropy}};

CREATE TABLE {{.scratch_schema}}.pv_events_staged{{.entropy}}
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
   {{.tenant_schema}}.sp_tracker c on c.tracker_name = a.name_tracker
       INNER JOIN
   {{.scratch_schema}}.pv_ids_staged{{.entropy}} d on d.id = b.id
   where a.event in ('page_view','page_ping')
);

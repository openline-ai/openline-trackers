DROP TABLE IF EXISTS {{.scratch_schema}}.app_info_this_run{{.entropy}};

create table {{.scratch_schema}}.app_info_this_run{{.entropy}} as (
    SELECT
    nextval('{{.output_schema}}.shared_id_seq') as id,
    b.tenant as tenant,
    a.name_tracker as name_tracker,
    a.app_id as app_id,
    a.platform as platform,
    max (collector_tstamp) as updated_on
    FROM {{.input_schema}}.events a
    inner join {{.tenant_schema}}.{{.tracker_table}} b on a.name_tracker = b.tracker_name and a.app_id = b.app_id
    where a.collector_tstamp >= (select max(run_id) from {{.output_schema}}.info_last_success_run_id{{.entropy}})
    and a.collector_tstamp <= (select max(run_id) from {{.scratch_schema}}.metadata_run_id{{.entropy}})
    GROUP BY 2, 3, 4, 5
);
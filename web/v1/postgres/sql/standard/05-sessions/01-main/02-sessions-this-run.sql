DROP TABLE IF EXISTS {{.scratch_schema}}.session_ids_this_run{{.entropy}};

create table {{.scratch_schema}}.session_ids_this_run{{.entropy}} as (
    select a.domain_sessionid,
    a.app_id,
    a.name_tracker,
    b.tenant
    FROM {{.input_schema}}.events a
    inner join {{.tenant_schema}}.sp_tracker b on b.tracker_name = a.name_tracker
    where a.collector_tstamp >= (select max(run_id) from {{.output_schema}}.sessions_last_success_run_id{{.entropy}})
    and a.collector_tstamp <= (select max(run_id) from {{.scratch_schema}}.metadata_run_id{{.entropy}})
    group by 1,2,3,4
)
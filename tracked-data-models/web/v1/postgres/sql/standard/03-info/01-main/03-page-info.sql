DROP TABLE IF EXISTS {{.scratch_schema}}.page_info_this_run{{.entropy}};

create table {{.scratch_schema}}.page_info_this_run{{.entropy}} as (
select *, nextval('{{.output_schema}}.shared_id_seq')       as id
    from (SELECT b.tenant                                            as tenant,
          a.name_tracker                                                        as name_tracker,
          a.app_id                                                              as app_id,
          a.page_url                                                            as page_url,
          a.page_title                                                          as page_title,
          a.collector_tstamp                                                    as updated_on,
          a.derived_tstamp                                                      as last_visit,
          row_number() over (partition by a.name_tracker, a.page_url order by a.derived_tstamp desc ) as row_number
    FROM {{.input_schema}}.events a
    inner join {{.tenant_schema}}.{{.tracker_table}} b on b.tracker_name = a.name_tracker and a.app_id = b.app_id
    where a.event IN ('page_view')
    and a.collector_tstamp >= (select max(run_id) from {{.output_schema}}.info_last_success_run_id{{.entropy}})
    and a.collector_tstamp <= (select max(run_id) from {{.scratch_schema}}.metadata_run_id{{.entropy}})) as inner_table
    where row_number = 1
);
update {{.scratch_schema}}.info_metadata_this_run{{.entropy}}
    set rows_this_run = (select count(*) from {{.scratch_schema}}.page_info_this_run{{.entropy}});
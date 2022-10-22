{{if eq .cleanup true}}
    DROP TABLE IF EXISTS {{.scratch_schema}}.app_info_this_run{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.page_info_this_run{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.info_metadata_this_run{{.entropy}};
{{else}} select 1;
{{end}}
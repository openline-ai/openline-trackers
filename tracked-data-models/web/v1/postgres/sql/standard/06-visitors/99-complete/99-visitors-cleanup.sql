{{if eq .cleanup true}}
    DROP TABLE IF EXISTS {{.scratch_schema}}.visitors_aggregates{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.visitors_lasts{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.visitors_run_metadata_temp{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.visitors_metadata_this_run{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.visitors_userids_this_run{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.visitors_limits{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.visitors_this_run{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.visitors_sessions_this_run{{.entropy}};
{{else}} select 1;
{{end}}
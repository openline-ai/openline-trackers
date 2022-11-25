{{if eq .cleanup true}}
    DROP TABLE IF EXISTS {{.scratch_schema}}.page_views_staged{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.sessions_aggregates{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.sessions_lasts{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.sessions_run_metadata_temp{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.sessions_metadata_this_run{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.sessions_visitorid_manifest_this_run{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.sessions_this_run{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.session_ids_this_run{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.sessions_upsert_limit{{.entropy}};
{{else}} select 1;
{{end}}
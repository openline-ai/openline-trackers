TRUNCATE {{.scratch_schema}}.page_views_staged{{.entropy}};
TRUNCATE {{.scratch_schema}}.sessions_aggregates{{.entropy}};
TRUNCATE {{.scratch_schema}}.sessions_lasts{{.entropy}};
TRUNCATE {{.scratch_schema}}.sessions_run_metadata_temp{{.entropy}};
TRUNCATE {{.scratch_schema}}.sessions_metadata_this_run{{.entropy}};
TRUNCATE {{.scratch_schema}}.sessions_userid_manifest_this_run{{.entropy}};
TRUNCATE {{.scratch_schema}}.sessions_this_run{{.entropy}};

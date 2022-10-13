TRUNCATE {{.scratch_schema}}.users_aggregates{{.entropy}};
TRUNCATE {{.scratch_schema}}.users_lasts{{.entropy}};
TRUNCATE {{.scratch_schema}}.users_run_metadata_temp{{.entropy}};
TRUNCATE {{.scratch_schema}}.users_metadata_this_run{{.entropy}};
TRUNCATE {{.scratch_schema}}.users_userids_this_run{{.entropy}};
TRUNCATE {{.scratch_schema}}.users_limits{{.entropy}};
TRUNCATE {{.scratch_schema}}.users_this_run{{.entropy}};
TRUNCATE {{.scratch_schema}}.users_sessions_this_run{{.entropy}};
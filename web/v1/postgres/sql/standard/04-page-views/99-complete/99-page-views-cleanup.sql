{{if eq .cleanup true}}
    DROP TABLE IF EXISTS {{.scratch_schema}}.pv_events_staged{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.pv_engaged_time{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.pv_scroll_depth{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.pv_metadata_this_run{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.pv_run_dupe_metadata_temp{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.pv_run_metadata_temp{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.pv_addon_ua_parser{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.pv_addon_yauaa{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.pv_page_view_events{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.page_views_this_run{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.pv_page_view_id_duplicates_this_run{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.pv_upsert_limit{{.entropy}};
    DROP TABLE IF EXISTS {{.scratch_schema}}.pv_ids_staged{{.entropy}};
{{else}} select 1;
{{end}}
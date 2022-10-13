BEGIN;

-- app info
INSERT INTO {{.output_schema}}.app_info{{.entropy}} (id, tenant, name_tracker, app_id, platform, updated_on)
    SELECT  a.id, a.tenant, a.name_tracker, a.app_id, a.platform, a.updated_on
    FROM    {{.scratch_schema}}.app_info{{.entropy}} a left join
            {{.output_schema}}.app_info{{.entropy}} b
    on a.tenant = b.tenant and a.name_tracker = b.name_tracker and a.app_id = b.app_id and a.platform = b.platform
    where   b.tenant is null;

-- page info update existing page titles
UPDATE
    {{.output_schema}}.page_info{{.entropy}}
SET
    page_title = scratchTable.page_title,
    updated_on = scratchTable.updated_on
from {{.output_schema}}.page_info{{.entropy}} outputTable inner join
    {{.scratch_schema}}.page_info{{.entropy}} scratchTable
    on outputTable.name_tracker = scratchTable.name_tracker
    and outputTable.app_id = scratchTable.app_id
    and outputTable.page_url = scratchTable.page_url
    and outputTable.tenant = scratchTable.tenant;

-- page info add new pages
INSERT INTO {{.output_schema}}.page_info{{.entropy}} (id, tenant, name_tracker, app_id, page_url, page_title, updated_on)
    SELECT  a.id, a.tenant, a.name_tracker, a.app_id, a.page_url, a.page_title, a.updated_on
    FROM    {{.scratch_schema}}.page_info{{.entropy}} a left join
            {{.output_schema}}.page_info{{.entropy}} b
    on a.tenant = b.tenant and a.name_tracker = b.name_tracker and a.app_id = b.app_id and a.page_url = b.page_url
where   b.tenant is null;


-- Commit last success run id
update {{.output_schema}}.info_last_success_run_id{{.entropy}}
    set run_id = (select run_id from {{.scratch_schema}}.metadata_run_id{{.entropy}});


-- Commit metadata
INSERT INTO {{.output_schema}}.datamodel_metadata{{.entropy}} (
    SELECT
    run_id,
    model_version,
    model,
    module,
    run_start_tstamp,
    run_end_tstamp,
    rows_this_run,
    distinct_key,
    distinct_key_count,
    time_key,
    min_time_key,
    max_time_key,
    duplicate_rows_removed,
    distinct_keys_removed
    FROM {{.scratch_schema}}.info_metadata_this_run{{.entropy}}
);

END;
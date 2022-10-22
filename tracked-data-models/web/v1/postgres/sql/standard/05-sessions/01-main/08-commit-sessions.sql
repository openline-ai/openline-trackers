
-- Create upsert limit
DROP TABLE IF EXISTS {{.scratch_schema}}.sessions_upsert_limit{{.entropy}};

CREATE TABLE {{.scratch_schema}}.sessions_upsert_limit{{.entropy}} AS (
  SELECT
    min(start_tstamp) AS lower_limit
  FROM {{.scratch_schema}}.sessions_this_run{{.entropy}}
);

BEGIN;

    -- Commit production table
    DELETE FROM {{.output_schema}}.sessions{{.entropy}}
      WHERE domain_sessionid IN (SELECT domain_sessionid FROM {{.scratch_schema}}.sessions_this_run{{.entropy}})
      AND start_tstamp >= (SELECT lower_limit FROM {{.scratch_schema}}.sessions_upsert_limit{{.entropy}});

    INSERT INTO {{.output_schema}}.sessions{{.entropy}}
      (SELECT * FROM {{.scratch_schema}}.sessions_this_run{{.entropy}});

    -- Commit staging manifest if enabled
    DELETE FROM {{.scratch_schema}}.sessions_userid_manifest_staged{{.entropy}}
      WHERE domain_userid IN (SELECT domain_userid FROM {{.scratch_schema}}.sessions_userid_manifest_this_run{{.entropy}});

    INSERT INTO {{.scratch_schema}}.sessions_userid_manifest_staged{{.entropy}}
      (SELECT * FROM {{.scratch_schema}}.sessions_userid_manifest_this_run{{.entropy}});

  -- Commit metadata
  INSERT INTO {{.output_schema}}.datamodel_metadata{{.entropy}} (
    SELECT
      run_id,
      model_version,
      model,
      module,
      run_start_tstamp,
      now() AS run_end_tstamp,
      rows_this_run,
      distinct_key,
      distinct_key_count,
      time_key,
      min_time_key,
      max_time_key,
      duplicate_rows_removed,
      distinct_keys_removed
    FROM {{.scratch_schema}}.sessions_metadata_this_run{{.entropy}}
  );

-- Commit last success run id
update {{.output_schema}}.sessions_last_success_run_id{{.entropy}}
    set run_id = (select run_id from {{.scratch_schema}}.metadata_run_id{{.entropy}});

END;

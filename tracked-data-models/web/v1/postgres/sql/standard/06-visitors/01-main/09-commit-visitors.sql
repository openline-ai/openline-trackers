BEGIN;

    -- Commit production table
    DELETE FROM {{.output_schema}}.visitors{{.entropy}}
      WHERE domain_userid IN (SELECT domain_userid FROM {{.scratch_schema}}.visitors_this_run{{.entropy}})
        AND start_tstamp >= (SELECT lower_limit FROM {{.scratch_schema}}.visitors_limits{{.entropy}});

    INSERT INTO {{.output_schema}}.visitors{{.entropy}}
      (SELECT * FROM {{.scratch_schema}}.visitors_this_run{{.entropy}});

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
    FROM {{.scratch_schema}}.visitors_metadata_this_run{{.entropy}}
  );

-- Commit last success run id
update {{.output_schema}}.visitors_last_success_run_id{{.entropy}}
    set run_id = (select run_id from {{.scratch_schema}}.metadata_run_id{{.entropy}});

END;

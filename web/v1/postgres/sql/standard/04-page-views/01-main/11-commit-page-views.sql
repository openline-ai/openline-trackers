-- Create upsert limit
DROP TABLE IF EXISTS {{.scratch_schema}}.pv_upsert_limit{{.entropy}};

CREATE TABLE {{.scratch_schema}}.pv_upsert_limit{{.entropy}} AS (
  SELECT
    min(start_tstamp) AS lower_limit
  FROM {{.scratch_schema}}.page_views_this_run{{.entropy}}
);

BEGIN;

    -- Commit production table
    DELETE FROM {{.output_schema}}.page_views{{.entropy}}
      WHERE page_view_id IN (SELECT page_view_id FROM {{.scratch_schema}}.page_views_this_run{{.entropy}})
        AND start_tstamp >= (SELECT lower_limit FROM {{.scratch_schema}}.pv_upsert_limit{{.entropy}});

    INSERT INTO {{.output_schema}}.page_views{{.entropy}}
      (SELECT * FROM {{.scratch_schema}}.page_views_this_run{{.entropy}});

    -- Commit staging table
    DELETE FROM {{.scratch_schema}}.page_views_staged{{.entropy}}
      WHERE page_view_id IN (SELECT page_view_id FROM {{.scratch_schema}}.page_views_this_run{{.entropy}});

    INSERT INTO {{.scratch_schema}}.page_views_staged{{.entropy}}
      (SELECT * FROM {{.scratch_schema}}.page_views_this_run{{.entropy}});

  -- Update previous page views with correct amount of pageviews in session
    WITH temp AS (
        SELECT domain_sessionid, MAX(page_views_in_session) as pvs_in_session
        FROM
            {{.output_schema}}.page_views{{.entropy}}
        WHERE collector_tstamp >= (select max(run_id) + INTERVAL '-{{.look_back_days}} day'  from {{.output_schema}}.pv_last_success_run_id{{.entropy}})
        GROUP BY domain_sessionid
    )
    UPDATE {{.output_schema}}.page_views{{.entropy}} a
    SET page_views_in_session = temp.pvs_in_session
        FROM temp
    WHERE temp.domain_sessionid = a.domain_sessionid
      and collector_tstamp >= (select max(run_id) + INTERVAL '-{{.look_back_days}} day'  from {{.output_schema}}.pv_last_success_run_id{{.entropy}});

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
    FROM {{.scratch_schema}}.pv_metadata_this_run{{.entropy}}
  );

-- Commit last success run id
update {{.output_schema}}.pv_last_success_run_id{{.entropy}}
    set run_id = (select run_id from {{.scratch_schema}}.metadata_run_id{{.entropy}});

END;

-- Create a limit for this run - single value table.
DROP TABLE IF EXISTS {{.scratch_schema}}.visitors_sessions_this_run{{.entropy}};

CREATE TABLE {{.scratch_schema}}.visitors_sessions_this_run{{.entropy}}
AS(
  SELECT
    a.*
  FROM {{.output_schema}}.sessions{{.entropy}} a
  INNER JOIN {{.scratch_schema}}.visitors_userids_this_run{{.entropy}} b
  ON a.domain_userid = b.domain_userid

  WHERE a.start_tstamp >= (SELECT lower_limit FROM {{.scratch_schema}}.visitors_limits{{.entropy}})
  AND   a.start_tstamp <= (SELECT upper_limit FROM {{.scratch_schema}}.visitors_limits{{.entropy}})
);

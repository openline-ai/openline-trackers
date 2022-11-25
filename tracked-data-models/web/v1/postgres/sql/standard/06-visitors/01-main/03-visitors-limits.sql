-- Create a limit for this run - single value table.
DROP TABLE IF EXISTS {{.scratch_schema}}.visitors_limits{{.entropy}};

CREATE TABLE {{.scratch_schema}}.visitors_limits{{.entropy}} AS(
  SELECT
    MIN(start_tstamp) AS lower_limit,
    MAX(start_tstamp) AS upper_limit

  FROM
    {{.scratch_schema}}.visitors_userids_this_run{{.entropy}}
);

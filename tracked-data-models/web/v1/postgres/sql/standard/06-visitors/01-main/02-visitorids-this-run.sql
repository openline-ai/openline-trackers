-- Create a limit for this run - single value table.
DROP TABLE IF EXISTS {{.scratch_schema}}.visitors_userids_this_run{{.entropy}};

CREATE TABLE {{.scratch_schema}}.visitors_userids_this_run{{.entropy}}
AS(
  SELECT
    a.domain_userid,
    LEAST(a.start_tstamp, b.start_tstamp) AS start_tstamp


  FROM
    {{.scratch_schema}}.sessions_visitorid_manifest_staged{{.entropy}} a
  LEFT JOIN
    {{.output_schema}}.visitors_manifest{{.entropy}} b
    ON a.domain_userid = b.domain_userid
);

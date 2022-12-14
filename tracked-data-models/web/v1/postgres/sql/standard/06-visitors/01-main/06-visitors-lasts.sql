
DROP TABLE IF EXISTS {{.scratch_schema}}.visitors_lasts{{.entropy}};

CREATE TABLE {{.scratch_schema}}.visitors_lasts{{.entropy}}
AS(
  SELECT
    a.domain_userid,
    a.last_page_title,

    a.last_page_url,

    a.last_page_urlscheme,
    a.last_page_urlhost,
    a.last_page_urlpath,
    a.last_page_urlquery,
    a.last_page_urlfragment

  FROM
    {{.scratch_schema}}.visitors_sessions_this_run{{.entropy}} a

  INNER JOIN {{.scratch_schema}}.visitors_aggregates{{.entropy}} b
  ON a.domain_userid = b.domain_userid
  AND a.end_tstamp = b.end_tstamp
)

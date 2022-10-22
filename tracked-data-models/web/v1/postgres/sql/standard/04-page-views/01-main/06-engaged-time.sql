DROP TABLE IF EXISTS {{.scratch_schema}}.pv_engaged_time{{.entropy}};

CREATE TABLE {{.scratch_schema}}.pv_engaged_time{{.entropy}}
AS(
	SELECT
    ev.page_view_id,
    MAX(ev.derived_tstamp) AS end_tstamp,
    FLOOR(EXTRACT(EPOCH FROM max(ev.derived_tstamp) - min(ev.derived_tstamp))) AS engaged_time_in_s
	FROM {{.scratch_schema}}.pv_events_staged{{.entropy}} AS ev
	WHERE ev.event_name in('page_ping','page_view')
  GROUP BY 1
);

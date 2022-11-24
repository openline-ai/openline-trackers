BEGIN;
  -- Update manifest
  DELETE
    FROM {{.output_schema}}.visitors_manifest{{.entropy}}
    WHERE domain_userid IN (SELECT domain_userid FROM {{.scratch_schema}}.visitors_userids_this_run{{.entropy}});

  INSERT INTO {{.output_schema}}.visitors_manifest{{.entropy}} (SELECT * FROM {{.scratch_schema}}.visitors_userids_this_run{{.entropy}});

  TRUNCATE {{.scratch_schema}}.sessions_visitorid_manifest_staged{{.entropy}};
{{if eq .cleanup true}}
  DROP TABLE IF EXISTS {{.scratch_schema}}.sessions_visitorid_manifest_staged{{.entropy}};
{{end}}
END;

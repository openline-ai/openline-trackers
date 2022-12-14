DROP TABLE IF EXISTS {{.scratch_schema}}.pv_page_view_events{{.entropy}};

CREATE TABLE {{.scratch_schema}}.pv_page_view_events{{.entropy}}
AS(
  SELECT

    ev.page_view_id,
    ev.event_id,

    ev.app_id,
    ev.name_tracker,

    -- user fields
    ev.user_id as visitor_id,
    ev.domain_userid,
    ev.network_userid,
    null as customer_os_contact_id,

    -- session fields
    ev.domain_sessionid,
    ev.domain_sessionidx,

    -- timestamp fields
    ev.dvce_created_tstamp,
    ev.collector_tstamp,
    ev.derived_tstamp,
    ev.derived_tstamp AS start_tstamp,

    ev.doc_width,
    ev.doc_height,

    ev.page_title,
    ev.page_url,
    ev.page_urlscheme,
    ev.page_urlhost,
    ev.page_urlpath,
    ev.page_urlquery,
    ev.page_urlfragment,

    ev.mkt_medium,
    ev.mkt_source,
    ev.mkt_term,
    ev.mkt_content,
    ev.mkt_campaign,
    ev.mkt_clickid,
    ev.mkt_network,

    ev.page_referrer,
    ev.refr_urlscheme ,
    ev.refr_urlhost,
    ev.refr_urlpath,
    ev.refr_urlquery,
    ev.refr_urlfragment,
    ev.refr_medium,

    CASE
        WHEN ev.refr_source is not null
            THEN ev.refr_source
        WHEN ev.refr_urlhost like '%ycombinator.com'
            THEN 'YCombinator'
        WHEN ev.refr_urlhost = 'vercel.com'
            THEN 'Vercel'
        WHEN ev.refr_urlhost = 'com.linkedin.android'
            THEN 'LinkedIn'
        WHEN page_referrer is null
            THEN 'Direct'
        WHEN refr_medium = 'internal'
            THEN 'Internal'
        ELSE 'Other'
    END AS refr_source,

    ev.refr_term,

    ev.geo_country,
    ev.geo_region,
    ev.geo_region_name,
    ev.geo_city,
    ev.geo_zipcode,
    ev.geo_latitude,
    ev.geo_longitude,
    ev.geo_timezone ,

    ev.user_ipaddress,

    ev.useragent,

    ev.br_lang,
    ev.br_viewwidth,
    ev.br_viewheight,
    ev.br_colordepth,
    ev.br_renderengine,
    ev.os_timezone,

    ROW_NUMBER() OVER (PARTITION BY ev.domain_sessionid ORDER BY ev.derived_tstamp) AS page_view_in_session_index

  FROM {{.scratch_schema}}.pv_events_staged{{.entropy}} AS ev

  WHERE ev.event_name = 'page_view'
  AND ev.page_view_id IS NOT NULL

--   {{if eq .ua_bot_filter true}}
--     AND ev.useragent NOT SIMILAR TO '%(bot|crawl|slurp|spider|archiv|spinn|sniff|seo|audit|survey|pingdom|worm|capture|(browser|screen)shots|analyz|index|thumb|check|facebook|PingdomBot|PhantomJS|YandexBot|Twitterbot|a_archiver|facebookexternalhit|Bingbot|BingPreview|Googlebot|Baiduspider|360(Spider|User-agent)|semalt)%'
--   {{end}}
);

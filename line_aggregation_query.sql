WITH segments as (
 select segment_line(the_geom) as seg, subway_users
 from l_subway_users_from_census_tracks
 where time < 1200
)

 
select ST_TRANSFORM(seg, 3857) as the_geom_webmercator, sum(subway_users)
from segments
group by seg

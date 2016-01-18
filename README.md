# Title pending

[![img](imgs/brooklyn-network.png)](https://team.cartodb.com/u/mamataakella/viz/fdbcdcba-bd4f-11e5-b5f0-0e674067d321/embed_map)

Earlier last week, news came out that the MTA was considering how to repair damages to the tunnel used by the L train to connect Manhattan and Brooklyn. The damages were caused by flooding during Hurricane Sandy and their repair may have big consequences for L train riders in the near future. As the MTA weighs the options, which include a full closing of the L train during repairs, or a longer period with weekend only closures, CartoDB wanted to dig in and look at what L train disruption looked like to the population of Brooklyn. How many, what backgrounds, and what alternatives are out there for what may come to the L.

### The L Train

[![L overview](imgs/draft-l-overview.png)](https://team.cartodb.com/u/mamataakella/viz/df39c134-bd38-11e5-927e-0ecfd53eb7d3/embed_map)

The L train is an East-West artery of the city, connecting Manhattan with many parts of Brooklyn. If you know people that live in Williamsburg and commute to Manhattan in the morning, you've probably heard the stories of morning commutes where only place to put your arms is on shoulders of the people sardined beside you. In recent years, it has been one of the fastest growing subway lines in terms of ridership, with just the Bedford Avenue stop in Williamsburg seeing [27,224 average weekday customers](http://www.mta.info/news-subway-new-york-city-transit/2015/04/20/subway-ridership-surges-26-one-year) back in 2014. Besides the crowds, the L is a [pretty convenient train](https://en.wikipedia.org/wiki/Automation_of_the_New_York_City_Subway#Canarsie_Line_CBTC).

### So who cares about an outage?

_(We starting thinking that many of the inhabitants along the L line who work in Manhattan, likely chose the line for it's conveniently close proximity to work.)
(need to fix the below. right now Y=%Riders in each block. Need Y=%Riders to Manhattan in each block)_

![ridership](imgs/ride-durations.png)

_What we see is a very strong relationship between total commute time to manhattan and the ratio of the over-16 population that takes the subway to get to work. This makes a lot of intuitive sense. The mechanisms behind it could come from a few different places,_

* People choose where they live to make their trips to work more bearable.
* When looking for jobs, people may be more likely to seek employment in places with easier access.
* _What other obvious ones?_

Here, let's look at the parts of Brooklyn where the L is the closest train to walk to and relative travel time to Manhattan...

[![L travel time](imgs/draft-travel-time.png)](https://team.cartodb.com/u/andrew/viz/77b936de-bd60-11e5-81b8-0ecfd53eb7d3/public_map?redirected=true)

_more about the above_. Use of Mapzen's Tangram yada yada

There are a lot of assumptions in the above map, so we tried to drill down a bit further. By combining population data, subway ridership data, and the proportion of people in each location that travel to Manhattan for work, we are able to make estimates of the foot-traffic for every Brooklyn census block serviced by the L. With CartoDB, we are able to split up every unique route from home to the L entrences and determine segment-by-segment foot-traffic.

[![foot traffic](imgs/draft-foot-traffic.png)](https://team.cartodb.com/u/stuartlynn/viz/25150cda-bd5d-11e5-a486-0e5db1731f59/public_map)

_If you are Uber or Lift, this might be the start to understanding where you will put advertising in the next year_

#### The demographics

There are a lot of different ways you can split the L ridership using parameters of the US Census.

[![bivariate of poverty](imgs/draft-poverty-ridership.png)](https://team.cartodb.com/u/stuartlynn/viz/faa6fe76-bd67-11e5-98e2-0ecd1babdde5/public_map)

### A disruption of epic proportions?

_about the headline of epic proportions in news. how epic would it be?_

[![alternate route](imgs/draft-bus-shuttle-option.png)](https://team.cartodb.com/u/andrew/viz/daa3e144-bd7f-11e5-81b1-0e3ff518bd15/public_map?redirected=true)


(but people can't always move)



##

How to create new estimate of best commute option with bus vs backtrack to M or A

```
update total_time_to_manhattan_2 set az_route =
case when az_s_cost+az_time_to_s+29 < least(az_a_cost+az_time_to_a, az_m_cost+ az_time_to_m) then 'S' ELSE
case when az_a_cost+az_time_to_a < az_m_cost+ az_time_to_m then 'A' ELSE
'M'
END
END
```

Get sums of riders per option weighted by lodes to manhattan

```
SELECT sum(subway_elevated_public_transit_commuters_16_and_over * (lodes_jobs_bk_mh/lodes_pop::numeric)), az_route FROM total_time_to_manhattan_2 group by az_route

```

Get sums of riders per option

```
SELECT sum(subway_elevated_public_transit_commuters_16_and_over), az_route FROM andrew.total_time_to_manhattan_2 group by az_route
```

The MTA periodically releases data about [subway ridership](http://web.mta.info/nyct/facts/ridership/) but knowing who those people are takes a bit more work.

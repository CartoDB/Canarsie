-- isolate brooklyn (36047) and manhattan (36061) work and home blocks from
-- the NY origin-destination file

-- this was run in sqlite after importing the OD file

.mode csv
.headers on
.output bk_mn_od.csv


-- select origin-destination involving brooklyn or manhattan
SELECT *
FROM ny_od_main_JT00_2013
WHERE
w_geocode / 10000000000 = 36047 OR
w_geocode / 10000000000 = 36061 OR
h_geocode / 10000000000 = 36047 OR
h_geocode / 10000000000 = 36061;

-- select # of jobs by block, and % telecommutable
.mode csv
.headers on
.output bk_rac_telecommute.csv
SELECT h_geocode,
       C000 total_jobs,
       CNS09 + CNS12 telecommutable,
       CAST(CNS09 + CNS12 AS FLOAT) / C000 telecommutable_rate
FROM ny_rac_S000_JT00_2013
WHERE h_geocode LIKE '36047%'
ORDER BY CAST(CNS09 + CNS12 AS FLOAT) / C000 DESC;

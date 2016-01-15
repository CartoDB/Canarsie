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


-- in postgres!
COPY (select substr(geoid, 8, 100) as geoid, geom,
       b01001001 as pop,
       b01001003 + b01001027 as age_under_5,
       b01001004 + b01001028 as age_5_9,
       b01001005 + b01001029 as age_10_14,
       b01001006 + b01001030 as age_15_17,
       b01001007 + b01001031 as age_18_19,
       b01001008 + b01001032 as age_20,
       b01001009 + b01001033 as age_21,
       b01001010 + b01001034 as age_22_24,
       b01001011 + b01001035 as age_25_29,
       b01001012 + b01001036 as age_30_34,
       b01001013 + b01001037 as age_35_39,
       b01001014 + b01001038 as age_40_44,
       b01001015 + b01001039 as age_45_49,
       b01001016 + b01001040 as age_50_54,
       b01001017 + b01001041 as age_55_59,
       b01001018 + b01001042 as age_60_61,
       b01001019 + b01001043 as age_62_64,
       b01001020 + b01001044 as age_65_66,
       b01001021 + b01001045 as age_67_69,
       b01001022 + b01001046 as age_70_74,
       b01001023 + b01001047 as age_75_79,
       b01001024 + b01001048 as age_80_84,
       b01001025 + b01001049 as age_85_and_over,
       b03002003 as white,
       b03002004 as black,
       b03002006 as asian,
       b03002012 as hispanic,
       b17001001 as pop_known_if_in_poverty,
       b17001002 as pop_in_poverty,
       b17001002::numeric/NULLIF(b17001001, 0) as ratio_poverty,
       b19001001 as households,
       b19001001 as households_income_10000_or_less,
       b19001002 as households_income_10000_14999,
       b19001003 as households_income_15000_19999,
       b19001004 as households_income_20000_24999,
       b19001005 as households_income_25000_29999,
       b19001006 as households_income_30000_34999,
       b19001007 as households_income_35000_39999,
       b19001008 as households_income_40000_44999,
       b19001009 as households_income_45000_49999,
       b19001010 as households_income_50000_54999,
       b19001011 as households_income_55000_59999,
       b19001012 as households_income_60000_74999,
       b19001013 as households_income_75000_99999,
       b19001014 as households_income_100000_124999,
       b19001015 as households_income_125000_149999,
       b19001016 as households_income_150000_199999,
       b19001017 as households_income_200000_or_more,
       b08134001 as commuters_16_and_over,
       b08134011 as car_commuters_16_and_over,
       b08134061 as public_transit_commuters_16_and_over,
       b08134071 as bus_public_transit_commuters_16_and_over,
       B08134081 as subway_elevated_public_transit_commuters_16_and_over,
       b08134101 as walked_commuters_16_and_over,
       b08134111 as other_commuters_16_and_over,
       b08134011::numeric/NULLIF(b08134001, 0) as ratio_car_commuters_16_and_over,
       b08134061::numeric/NULLIF(b08134001, 0) as ratio_public_transit_commuters_16_and_over,
       b08134071::numeric/NULLIF(b08134001, 0) as ratio_bus_public_transit_commuters_16_and_over,
       B08134081::numeric/NULLIF(b08134001, 0) as ratio_subway_elevated_public_transit_commuters_16_and_over,
       b08134101::numeric/NULLIF(b08134001, 0) as ratio_walked_commuters_16_and_over,
       b08134111::numeric/NULLIF(b08134001, 0) as ratio_other_commuters_16_and_over
from acs2013_5yr.census_extract_bg
WHERE geoid like '15000US36047%') TO '/tmp/census_extract_bk.csv' WITH CSV HEADER;

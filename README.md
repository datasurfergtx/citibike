# citibike
Citi Bike data exploration. This repository contains a library of [NYC citibike data](https://www.citibikenyc.com/system-data)

## fst Library
- This repo contains all NYC public citibike data (2013-06-01 to 2019-05-31) in fst files by day.
- The library contains 78,322,373 records.
- Records have had their columns renamed, datetimes set to POSIXct, and gender has been converted.

#### Data Columns 
Note: column names are different from the original dataset and the gender key has been changed
- ```start``` = start time
- ```end``` = end time
- ```time``` = trip time in seconds
- ```start_id``` = bike dock id on trip start station
- ```start_loc``` = bike dock location on trip start station
- ```start_lat``` = Latitude of bike dock location on trip start station
- ```start_lon``` = Longitude of bike dock location on trip start station
- ```end_id``` = bike dock id on trip end station
- ```end_loc``` = bike dock location on trip end station
- ```end_lat``` = Latitude of bike dock location on trip end station
- ```end_lon``` = Longitude of bike dock location on trip end station
- ```bikeid``` = bike id
- ```user```
  - "Customer" = 24-hour pass or 3-day pass user
  - "Subscriber" = Annual Member
- ```dob``` = birth year, there are NAs
- ```gender```
  - 0 = male
  - 1 = female
  - NA = unknown


## Coming Soon:
- Data Exploration will be coming soon. exploratory_analysis.R will contain all the fun analysis.

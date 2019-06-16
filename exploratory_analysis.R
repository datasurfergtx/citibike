setwd("~/Documents/R/citibike/fst/")
library(readr)
library(data.table)
library(bit64)
library(chron)
library(plotly)
library(dplyr)
library(ggplot2)
library(ggmap)
library(fst)
library(data.table)
library(rgdal)
library(scales)
library(ggthemes)
library(tidyr)
library(lubridate)
library(stringr)
library(zoo)
library(anytime)
library(geosphere)
library(pbapply)
library(rlist)
library(fasttime)
options(scipen =999)

test = read.fst("citi-2015-12-05.fst")

tripcount = seq.Date(as.Date("2013-05-31"), as.Date("2015-12-31"), by = "days") %>%
  pblapply(function(x){
    count = read.fst(list.files(pattern = as.character(x)), columns = c("starttime","tripduration","birth year","gender"))
    count = count %>% mutate(month = month(starttime), year = year(starttime)) %>% 
      group_by(month, year) %>%
      summarize(n = n(), time = mean(tripduration, na.rm = TRUE), age = 2019 - mean(`birth year`, na.rm = TRUE),
                female = mean(gender, na.rm = TRUE), male = 1 - mean(gender, na.rm = TRUE))
  }) %>% rbindlist()

 agg2 = tripcount %>% 
   group_by(year, month) %>% 
   summarize(n = sum(n), time = mean(time), age = mean(age), female = mean(female), male = mean(male)) %>%
   arrange(year, month)
 
agg %>% group_by(month, year) %>%
  mutate(trip_perc = lag())





setwd("~/Documents/R/citibike/fst2/")
tripcount = seq.Date(as.Date("2019-04-01"), as.Date("2019-04-30"), by = "days") %>%
  pblapply(function(x){
    count = read.fst(list.files(pattern = as.character(x)))
  }) %>% rbindlist()


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

#2013 files ####
setwd("~/Documents/R/temp/2013")
trips2013 = pblapply(list.files(pattern="*\\.csv"), function(x){
  fread(x) 
})%>% rbindlist()

#fix datetimes
a = ymd_hms(trips2013$starttime, tz = "America/New_York")
trips2013$starttime <- a

b = ymd_hms(trips2013$stoptime, tz = "America/New_York")
trips2013$stoptime <- b

#fix birth year
trips2013$`birth year` = as.numeric(trips2013$`birth year`)

#recoding male to 0 and female to 1 unknown is now NA
trips2013$gender = gsub(0,NA,trips2013$gender)
trips2013$gender = gsub("1","0",trips2013$gender)
trips2013$gender = gsub("2","1",trips2013$gender)
trips2013$gender = as.numeric(trips2013$gender)

#rename all columns
names(trips2013) = c("time","start","end","start_id","start_loc","start_lat","start_lon","end_id","end_loc","end_lat","end_lon","bikeid","user","dob","gender")

#fix end_id
trips2013$end_id = as.integer(trips2013$end_id)
#fix end_lat
trips2013$end_lat = as.numeric(trips2013$end_lat)
#fix end_lon
trips2013$end_lon = as.numeric(trips2013$end_lon)

#setup daily files
setwd("~/Documents/R/citibike/fst2")

trips2013$date = ymd(substr(trips2013$start,1,10))

x = seq.Date(as.Date('2013-06-01'),as.Date('2013-12-31'), by="days")


for (i in x){
  a <- trips2013 %>% dplyr::filter(date == i)
  a$date = NULL
  write.fst(a,paste0("citi-",as.Date(i),".fst"))
}


# test = read.fst("citi-2013-06-01.fst")


#2014 files ####
setwd("~/Documents/R/temp/2014")
trips2014 = pblapply(list.files(pattern="*\\.csv"), function(x){
  fread(x) 
})%>% rbindlist()

#fix datetimes

#starttimes
a = ymd_hms(trips2014$starttime, tz = "America/New_York")
b = mdy_hms(trips2014$starttime,tz = "America/New_York")

#check if our code worked
sum(is.na(a)) + sum(is.na(b))

#conversion
a[is.na(a)] <- b[!is.na(b)]
sum(is.na(a))
trips2014$starttime <- a
sum(is.na(trips2014$starttime))


#stoptimes
a = ymd_hms(trips2014$stoptime, tz = "America/New_York")
b = mdy_hms(trips2014$stoptime,tz = "America/New_York")

#check if our code worked
sum(is.na(a)) + sum(is.na(b))

#conversion
a[is.na(a)] <- b[!is.na(b)]
sum(is.na(a))
trips2014$stoptime <- a
sum(is.na(trips2014$stoptime))


#fix birth year
trips2014$`birth year` = as.numeric(trips2014$`birth year`)

#recoding male to 0 and female to 1 unknown is now NA
trips2014$gender = gsub(0,NA,trips2014$gender)
trips2014$gender = gsub("1","0",trips2014$gender)
trips2014$gender = gsub("2","1",trips2014$gender)
trips2014$gender = as.numeric(trips2014$gender)

#rename all columns
names(trips2014) = c("time","start","end","start_id","start_loc","start_lat","start_lon","end_id","end_loc","end_lat","end_lon","bikeid","user","dob","gender")

#setup daily files
setwd("~/Documents/R/citibike/fst2")

trips2014$date = ymd(substr(trips2014$start,1,10))

x = seq.Date(as.Date('2014-01-01'),as.Date('2014-12-31'), by="days")


for (i in x){
  a <- trips2014 %>% dplyr::filter(date == i)
  a$date = NULL
  write.fst(a,paste0("citi-",as.Date(i),".fst"))
}

# test = read.fst("citi-2014-01-01.fst")


#2015 files ####
setwd("~/Documents/R/temp/2014")
trips2014 = pblapply(list.files(pattern="*\\.csv"), function(x){
  fread(x) 
})%>% rbindlist()
#read in all csv files####
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

#2013 files
setwd("~/Documents/R/temp/2013")
trips2013 = pblapply(list.files(pattern="*\\.csv"), function(x){
  fread(x) 
})%>% rbindlist()

#clean 2013 data####

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

setwd("~/Documents/R/citibike/fst2")

trips2015$date = as.Date(substr(trips2015$starttime,1,10))

x = seq.Date(as.Date('2015-01-01'),as.Date('2015-12-31'), by="day")


for (i in x){
  a <- trips2015 %>% dplyr::filter(date == i)
  a$date = NULL
  write.fst(a,paste0("citi-",as.Date(i),".fst"))
}
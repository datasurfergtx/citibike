#read in all csv files####
setwd("C:\\Users\\lamja\\Documents\\R\\citibike")
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


#fix files with bad datetimes ####
setwd("C:\\Users\\lamja\\Documents\\R\\citibike\\weird files")
baddates = pblapply(list.files(pattern="*\\.csv"), function(x){
  fread(x) 
})%>% rbindlist()

baddates$starttime = parse_date_time(baddates$starttime, order = 'mdy HMS')
baddates$stoptime = parse_date_time(baddates$stoptime, order = 'mdy HMS')

# setwd("C:\\Users\\lamja\\Documents\\R\\citibike\\raw files")
# fwrite(baddates,"gooddates.csv")


#Load in larger dataset####
setwd("C:\\Users\\lamja\\Documents\\R\\citibike\\raw files")
setwd("~/Downloads/csvs")
trips = pblapply(list.files(pattern="*\\.csv"), function(x){
 fread(x) 
})%>% rbindlist()



#load in 2015 dataset####
setwd("~/Downloads/2015")
trips2015 = pblapply(list.files(pattern="*\\.csv"), function(x){
  fread(x) 
})%>% rbindlist()

# trips2015 = fread("201501-citibike-tripdata.csv")

#fixing two datetimes in one column####
a = parse_date_time(trips2015$starttime, order = 'mdy HMS', tz = "America/New_York")
b = parse_date_time(trips2015$starttime, order = 'mdy HM', tz= "America/New_York")

#check if our code worked
sum(is.na(a)) + sum(is.na(b))

a[is.na(a)] <- b[!is.na(b)]
sum(is.na(a))
trips2015$starttime <- a

# test = trips2015$starttime[is.na(b)]

#trip stoptime

a = parse_date_time(trips2015$stoptime, order = 'mdy HMS', tz = "America/New_York")
b = parse_date_time(trips2015$stoptime, order = 'mdy HM', tz = "America/New_York")

#check if our code worked
sum(is.na(a)) + sum(is.na(b))

a[is.na(a)] <- b[!is.na(b)]
sum(is.na(a))
trips2015$stoptime <- a


#clean up data####

# trips$starttime = fastPOSIXct(trips$starttime)
# trips$stoptime = fastPOSIXct(trips$stoptime)
trips2015$`end station id` = as.numeric(trips2015$`end station id`)
# trips$`end station latitude` = as.numeric(trips$`end station latitude`)
# trips$`end station longitude` = as.numeric(trips$`end station longitude`)
# trips$`birth year` = gsub("\\N",NA,trips$`birth year`)
trips2015$`birth year` = as.numeric(trips2015$`birth year`)

#recoding male to 0 and female to 1 unknown is now NA
trips2015$gender = gsub(0,NA,trips2015$gender)
trips2015$gender = gsub("1","0",trips2015$gender)
trips2015$gender = gsub("2","1",trips2015$gender)
trips2015$gender = as.numeric(trips2015$gender)


#loop to create daily fst files####
setwd("C:\\Users\\lamja\\Documents\\R\\citibike\\fst")
setwd("~/Documents/R/citibike/fst")

trips2015$date = as.Date(substr(trips2015$starttime,1,10))

x = seq.Date(as.Date('2015-01-01'),as.Date('2015-12-31'), by="day")


for (i in x){
  a <- trips2015 %>% dplyr::filter(date == i)
  a$date = NULL
  write.fst(a,paste0("citi-",as.Date(i),".fst"))
  }

#test
setwd("~/Documents/R/citibike/fst")
test = read.fst("citi-2013-07-01.fst")
test2 = read.fst("citi-2015-01-01.fst")
test3 = rbind(test,test2)






#load in 2016 and 2017 data####
# setwd("~/Documents/R/temp/2016")
setwd("~/Downloads/combined")

trips = pblapply(list.files(pattern="*\\.csv"), function(x){
  fread(x) 
})%>% rbindlist(use.names = FALSE)

#fixing two datetimes in one column####
# a = parse_date_time(trips$starttime, orders = 'mdy HMS')
# b = parse_date_time(trips$starttime, orders = 'ymd HMS')

a = ymd_hms(trips$starttime, tz = "America/New_York")
b = mdy_hms(trips$starttime,tz = "America/New_York")

# table(months(a), year(a))
# table(months(b), year(b))

#check if our code worked
sum(is.na(a)) + sum(is.na(b))

a[is.na(a)] <- b[!is.na(b)]
sum(is.na(a))
trips$starttime <- a
sum(is.na(trips$starttime))


#trip stoptime

a = ymd_hms(trips$stoptime)
b = mdy_hms(trips$stoptime)

#check if our code worked
sum(is.na(a)) + sum(is.na(b))

a[is.na(a)] <- b[!is.na(b)]
sum(is.na(a))
trips$stoptime <- a

#import to check data types
setwd("~/Documents/R/citibike/fst")
test = read.fst("citi-2013-07-01.fst")
#we need  end station id as num, fix birth year and gender.


#clean up data####

trips$`end station id` = as.numeric(trips$`end station id`)
trips$`birth year` = as.numeric(trips$`birth year`)

#recoding male to 0 and female to 1 unknown is now NA
trips$gender = gsub(0,NA,trips$gender)
trips$gender = gsub("1","0",trips$gender)
trips$gender = gsub("2","1",trips$gender)
trips$gender = as.numeric(trips$gender)


#loop to create daily fst files####
# setwd("C:\\Users\\lamja\\Documents\\R\\citibike\\fst")
setwd("~/Documents/R/citibike/fst")

trips$date = as.Date(substr(trips$starttime,1,10))

x = seq.Date(as.Date('2016-01-01'),as.Date('2017-12-31'), by="day")


for (i in x){
  a <- trips %>% dplyr::filter(date == i)
  a$date = NULL
  write.fst(a,paste0("citi-",as.Date(i),".fst"))
}
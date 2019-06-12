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

#fixing two datetimes in one column####
a = parse_date_time(trips2015$starttime, order = 'mdy HMS')
b = parse_date_time(trips2015$starttime, order = 'mdy HM')

#check if our code worked
sum(is.na(a)) + sum(is.na(b))

a[is.na(a)] <- b[!is.na(b)]
sum(is.na(a))
trips2015$starttime <- a

# test = trips2015$starttime[is.na(b)]

#trip stoptime

a = parse_date_time(trips2015$stoptime, order = 'mdy HMS')
b = parse_date_time(trips2015$stoptime, order = 'mdy HM')

#check if our code worked
sum(is.na(a)) + sum(is.na(b))

a[is.na(a)] <- b[!is.na(b)]
sum(is.na(a))
trips2015$stoptime <- a





#load in 2016 data####
setwd("~/Documents/R/temp/2016")
trips2016 = pblapply(list.files(pattern="*\\.csv"), function(x){
  fread(x) 
})%>% rbindlist()








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

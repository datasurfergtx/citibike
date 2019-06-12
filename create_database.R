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

test = read.fst("citi-2014-01-01.fst")


#2015 files ####
setwd("~/Documents/R/temp/2015")
trips = pblapply(list.files(pattern="*\\.csv"), function(x){
  fread(x) 
})%>% rbindlist()


#fix datetimes

#starttimes
a = mdy_hm(trips$starttime, tz = "America/New_York")
b = mdy_hms(trips$starttime,tz = "America/New_York")

#check if our code worked
sum(is.na(a)) + sum(is.na(b))

#conversion
a[is.na(a)] <- b[!is.na(b)]
sum(is.na(a))
trips$starttime <- a
sum(is.na(trips$starttime))


#stoptimes
a = mdy_hm(trips$stoptime, tz = "America/New_York")
b = mdy_hms(trips$stoptime,tz = "America/New_York")

#check if our code worked
sum(is.na(a)) + sum(is.na(b))

#conversion
a[is.na(a)] <- b[!is.na(b)]
sum(is.na(a))
trips$stoptime <- a
sum(is.na(trips$stoptime))

#birth year
trips$`birth year` = as.numeric(trips$`birth year`)

#recoding male to 0 and female to 1 unknown is now NA
trips$gender = gsub(0,NA,trips$gender)
trips$gender = gsub("1","0",trips$gender)
trips$gender = gsub("2","1",trips$gender)
trips$gender = as.numeric(trips$gender)

#rename all columns
names(trips) = c("time","start","end","start_id","start_loc","start_lat","start_lon","end_id","end_loc","end_lat","end_lon","bikeid","user","dob","gender")


#setup daily files
setwd("~/Documents/R/citibike/fst2")

trips$date = ymd(substr(trips$start,1,10))

x = seq.Date(as.Date('2015-01-01'),as.Date('2015-12-31'), by="days")


for (i in x){
  a <- trips %>% dplyr::filter(date == i)
  a$date = NULL
  write.fst(a,paste0("citi-",as.Date(i),".fst"))
}

# test = read.fst("citi-2015-05-10.fst")


#2016 files ####
setwd("~/Documents/R/temp/2016")
trips = pblapply(list.files(pattern="*\\.csv"), function(x){
  fread(x) 
})%>% rbindlist(use.names = FALSE)


#fix datetimes

#starttimes
a = ymd_hms(trips$starttime, tz = "America/New_York")
b = mdy_hms(trips$starttime,tz = "America/New_York")

#check if our code worked
sum(is.na(a)) + sum(is.na(b))

#conversion
a[is.na(a)] <- b[!is.na(b)]
sum(is.na(a))
trips$starttime <- a
sum(is.na(trips$starttime))


#stoptimes
a = ymd_hms(trips$stoptime, tz = "America/New_York")
b = mdy_hms(trips$stoptime,tz = "America/New_York")

#check if our code worked
sum(is.na(a)) + sum(is.na(b))

#conversion
a[is.na(a)] <- b[!is.na(b)]
sum(is.na(a))
trips$stoptime <- a
sum(is.na(trips$stoptime))

#birth year
trips$`birth year` = as.numeric(trips$`birth year`)

#recoding male to 0 and female to 1 unknown is now NA
trips$gender = gsub(0,NA,trips$gender)
trips$gender = gsub("1","0",trips$gender)
trips$gender = gsub("2","1",trips$gender)
trips$gender = as.numeric(trips$gender)

#rename all columns
names(trips) = c("time","start","end","start_id","start_loc","start_lat","start_lon","end_id","end_loc","end_lat","end_lon","bikeid","user","dob","gender")


#setup daily files
setwd("~/Documents/R/citibike/fst2")

trips$date = ymd(substr(trips$start,1,10))

x = seq.Date(as.Date('2016-01-27'),as.Date('2016-12-31'), by="days")


for (i in x){
  a <- trips %>% dplyr::filter(date == i)
  a$date = NULL
  write.fst(a,paste0("citi-",as.Date(i),".fst"))
}

#moving 4 records to different dates to keep the loop going
test = read.fst("citi-2016-01-22.fst")
testfinal = test[1:20946,]
z = test[20947,]
zz = test[20948,]
zzz = test[20949,]
zzzz = test[20950,]

write.fst(z,"citi-2016-01-23.fst")
write.fst(zz,"citi-2016-01-24.fst")
write.fst(zzz,"citi-2016-01-25.fst")
write.fst(zzzz,"citi-2016-01-26.fst")
write.fst(testfinal,"citi-2016-01-22.fst")



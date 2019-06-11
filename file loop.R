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


#clean up data####

trips$starttime = fastPOSIXct(trips$starttime)
trips$stoptime = fastPOSIXct(trips$stoptime)
trips$`end station id` = as.numeric(trips$`end station id`)
trips$`end station latitude` = as.numeric(trips$`end station latitude`)
trips$`end station longitude` = as.numeric(trips$`end station longitude`)
trips$`birth year` = gsub("\\N",NA,trips$`birth year`)
trips$`birth year` = as.numeric(trips$`birth year`)

#recoding male to 0 and female to 1 unknown is now NA
trips$gender = gsub(0,NA,trips$gender)
trips$gender = gsub("1","0",trips$gender)
trips$gender = gsub("2","1",trips$gender)
trips$gender = as.numeric(trips$gender)


#loop to create daily fst files####
setwd("C:\\Users\\lamja\\Documents\\R\\citibike\\fst")

trips$date = as.Date(substr(trips$starttime,1,10))

x = seq.Date(as.Date('2013-05-31'),as.Date('2014-12-31'), by="day")


for (i in x){
  a <- trips %>% dplyr::filter(date == i)
  a$date = NULL
  write.fst(a,paste0("citi-",as.Date(i),".fst"))
  
}

test2 = read.fst("citi-2013-07-01.fst")


#Method to extract two different dates in the same column
a <- as.Date(data$initialDiagnose,format="%m/%d/%Y") # Produces NA when format is not "%m/%d/%Y"
b <- as.Date(data$initialDiagnose,format="%d.%m.%Y") # Produces NA when format is not "%d.%m.%Y"
a[is.na(a)] <- b[!is.na(b)] # Combine both while keeping their ranks
data$initialDiagnose <- a # Put it back in your dataframe
data$initialDiagnose
[1] "2009-01-14" "2005-09-22" "2010-04-21" "2010-01-28" "2009-01-09" "2005-03-28" "2005-01-04" "2005-01-04" "2010-09-17" "2010-01-03"


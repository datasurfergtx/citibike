setwd("C:\\Users\\lamja\\Documents\\records")

x = seq.Date(as.Date('2018-04-01'),as.Date('2018-04-09'), by="day")


test <- head(wait,10000)
test$test <- ymd(substr(test$pudt,1,10))


for (i in x){
  aa <- test %>% dplyr::filter(test == i)
  
  write.fst(aa,paste0("TPEP",as.Date(i),".fst"))
  
}

testtest = read.fst("TPEP2018-04-01.fst")

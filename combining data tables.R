library(tidyverse)
library(data.table)
library(tictoc)

data_directory <- "./datatables/"
myfiles <- list.files(data_directory, pattern = "*RDS")

subfiles2 <- myfiles[str_detect(myfiles, "freq2")]
subfiles3 <- myfiles[str_detect(myfiles, "freq3") | str_detect(myfiles, "info_DT_3")]
subfiles4 <- myfiles[str_detect(myfiles, "freq4")]
subfiles5 <- myfiles[str_detect(myfiles, "freq5")]

subfilesx <- subfiles3

dt_list <- list()
m <- 1

for (i in subfilesx){
  
  print(subfilesx[m])
  
  assign(subfilesx[m], readRDS(paste0(data_directory,"/",subfilesx[m])))
  
  dt <- get(subfilesx[m])
  rm(list = ls(pattern = "^ngram_freq"))
  
  dt_list[[m]] <- dt
  
  m <- m + 1
  
}

saveRDS(dt_list,"./datatables/dt_list3.RDS")


datatables_sub1 <- readRDS("./datatables/datatables_sub1.RDS")
datatables_sub2 <- readRDS("./datatables/datatables_sub2.RDS")

list <- list(datatables_sub1, datatables_sub2)
rm(datatables_sub1)
rm(datatables_sub2)

datatables_sub3 <- readRDS("./datatables/datatables_sub3.RDS")
list[[3]] <- datatables_sub3
rm(datatables_sub3)

datatables_sub4 <- readRDS("./datatables/datatables_sub4.RDS")
list[[4]] <- datatables_sub4
rm(datatables_sub4)

datatables_sub5 <- readRDS("./datatables/datatables_sub5.RDS")
list[[5]] <- datatables_sub5
rm(datatables_sub5)

datatablesfull <- rbindlist(list)
saveRDS(datatablesfull, "./datatables/datatables_full.RDS")
n_bef <- NROW(datatablesfull); nbef
datatables_sub <- datatablesfull[, .(freq = sum(freq)), by = list(pred, ngram_1)]
n_aft <- NROW(datatables_sub); n_aft

saveRDS(datatables_sub, "./datatables/datatables_full_sub.RDS")
write_csv(datatables_sub, "./Word_Prediction/data/datatables_full_sub.csv")

#######################################

test_data <- datatables_sub[1:500]
test_data1 <- test_data[test_data[, .I[which.max(freq)], by = ngram_1]$V1]

datatables_min <- datatables_sub[datatables_sub[, .I[which.max(freq)], by = ngram_1]$V1]
saveRDS(datatables_min, "./Word_Prediction/data/datatables_min.RDS")
write_csv(datatables_min, "./Word_Prediction/data/datatables_min.csv")

datatables_min5 <- datatables_min[41200001:51500000]
saveRDS(datatables_min5, "./Word_Prediction/data/datatables_min5.RDS")
rm(datatables_min5)

datatables_min6 <- datatables_min[51500001:61800000]
saveRDS(datatables_min6, "./Word_Prediction/data/datatables_min6.RDS")
rm(datatables_min6)

datatables_min7 <- datatables_min[61800001:72100000]
saveRDS(datatables_min7, "./Word_Prediction/data/datatables_min7.RDS")
rm(datatables_min7)

n <- NROW(datatables_min)
datatables_min8 <- datatables_min[72100001:n]
saveRDS(datatables_min8, "./Word_Prediction/data/datatables_min8.RDS")
rm(datatables_min8)

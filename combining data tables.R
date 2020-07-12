library(tidyverse)
library(data.table)
library(tictoc)

data_directory <- "./datatables/"
myfiles <- list.files(data_directory, pattern = "*RDS")

subfiles1 <- myfiles[str_detect(myfiles, "freq1")]

dt_list <- list()
m <- 1
subfilesx <- subfiles1

for (i in subfilesx){
  
  print(subfilesx[m])
  
  assign(subfilesx[m], readRDS(paste0(data_directory,"/",subfilesx[m])))
  
  dt <- get(subfilesx[m])
  rm(list = ls(pattern = "^ngram_freq"))
  
  dt_list[[m]] <- dt
  
  m <- m + 1
  
}

   
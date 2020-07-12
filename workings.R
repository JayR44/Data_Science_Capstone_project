library(tidyverse)
library(tm)

file <- readRDS("./DATA/US_full_corpus_vec_wo_blanks.RDS")
df <- dataframe <- data.frame(text=unlist(sapply(file, `[`, "content")), 
                              stringsAsFactors=F)
file_to_use <- df[[1]]

n <- length(file_to_use)

file1 <- file_to_use[1:2000000]
file2 <- file_to_use[2000001:n]

length(file1)+length(file2)==n

saveRDS(file1, "./file1.RDS")
saveRDS(file2,"./file2.RDS")

############################
library(tidyverse)
library(quanteda)
library(tm)
library(data.table)
library(textclean)
library(ngram)
library(tictoc)

dt_list <- readRDS("./datatables/dt_list4.RDS")

tic("dt bind")
datatables <- rbindlist(dt_list)
n_comb <- NROW(datatables); n_comb
toc()
tic("group")
datatables_sub <- datatables[, .(freq = sum(freq)), by = list(pred, ngram_1)]
ngroup <- NROW(datatables_sub); ngroup
toc()

saveRDS(datatables_sub, "./datatables/datatables_sub4.RDS")
rm(datatables_sub)
rm(datatables)
rm(dt_list)

dt_list <- readRDS("./datatables/dt_list3.RDS")

tic("dt bind")
datatables <- rbindlist(dt_list)
n_comb <- NROW(datatables); n_comb
toc()
tic("group")
datatables_sub <- datatables[, .(freq = sum(freq)), by = list(pred, ngram_1)]
ngroup <- NROW(datatables_sub); ngroup
toc()

saveRDS(datatables_sub, "./datatables/datatables_sub3.RDS")
rm(datatables_sub)
rm(datatables)
rm(dt_list)

dt_list <- readRDS("./datatables/dt_list5.RDS")

tic("dt bind")
datatables <- rbindlist(dt_list)
n_comb <- NROW(datatables); n_comb
toc()
tic("group")
datatables_sub <- datatables[, .(freq = sum(freq)), by = list(pred, ngram_1)]
ngroup <- NROW(datatables_sub); ngroup
toc()

saveRDS(datatables_sub, "./datatables/datatables_sub5.RDS")
rm(datatables_sub)
rm(datatables)
rm(dt_list)

datatables_sub5 <- readRDS("./datatables/datatables_sub5.RDS")

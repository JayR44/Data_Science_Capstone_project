library(tidyverse)
library(tm)
library(tictoc)
library(quanteda)
library(data.table)

toks_full <- readRDS("./DATA/Full tokens list.RDS")
n <- length(toks_full); n

toks_sub <- toks_full[1:100000]

#Generate ngrams
toks_ngram <- tokens_ngrams(toks_sub, n = 2:5, concatenator = " ")

#Create document feature matrix
doc_feat_matrix <- dfm(toks_ngram)

#Obtain frequencies of each ngram
ngram_freq <- textstat_frequency(doc_feat_matrix) %>%
  select(ngram = feature, freq = frequency)

ngram_info <- ngram_freq %>%
  mutate(pred = word(ngram, -1),
         ngram_1 = str_replace(ngram, paste0(" ",pred, "$"),"")) %>%
  select(-ngram)

#Convert to datatable
ngram_table <- setDT(ngram_info)
saveRDS(ngram_table, "./sample_100000_table.RDS")

#############################

library(data.table)
library(tidyverse)
library(tictoc)

tic("1")
table_1 <<- readRDS("./Word_Prediction/data/datatables_min3.RDS")
toc()
tic("2")
table_2 <<- readRDS("./Word_Prediction/data/datatables_min5.RDS")
toc()
tic("3")
table_3 <<- readRDS("./Word_Prediction/data/datatables_min7.RDS")
toc()

tic("list")
l <- list(table_1, table_2, table_3)
toc()

tic("comb")
ngram_dt <- rbindlist(l)
toc()

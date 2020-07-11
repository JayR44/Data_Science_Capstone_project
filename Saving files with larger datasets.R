library(tidyverse)
library(quanteda)
library(tm)

file1 <- readRDS("./file1.RDS")
file2 <- readRDS("./file2.RDS")
combined <- c(file1, file2)

#Use sample to regenerate code
vec_cor_1000 <- readRDS("./DATA/US_corpus_vec.RDS")
df <- dataframe <- data.frame(text=unlist(sapply(vec_cor_1000, `[`, "content")), 
                              stringsAsFactors=F)
file_1000_to_use <- df[[1]]
saveRDS(file_1000_to_use, "./sample_1000_to_use.RDS")

##################### CREATE NGRAMS AND DATATABLE

library(tidyverse)
library(quanteda)
library(tm)
library(data.table)
library(textclean)
library(ngram)
library(tictoc)

sample_file <- readRDS("./DATA/sample_1000_to_use.RDS")

#Generate tokens
#toks <- tokens(sample_file)
toks <- readRDS("./DATA/Full tokens list.RDS")

#Generate ngrams
toks_ngram <- tokens_ngrams(toks, n = 2:5, concatenator = " ")

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

head(ngram_table)

###############################

toks_full_ngram1 <- readRDS("./DATA/toks_full_ngram1.RDS")
tic("produce dfm")
doc_feat_matrix1 <- dfm(toks_full_ngram1)
toc()
saveRDS(doc_feat_matrix1, "./DATA/doc_feat_matrix1.RDS")

ngram_freq1 <- textstat_frequency(doc_feat_matrix1) %>%
  select(ngram = feature, freq = frequency)
saveRDS(ngram_freq1, "./DATA/ngram_freq1.RDS")

ngram_freq3 <- readRDS("./DATA/ngram_freq3.RDS")
#ngram_info1 <- ngram_freq1 %>%
#  mutate(pred = word(ngram, -1),
#         ngram_1 = str_replace(ngram, paste0(" ",pred, "$"),"")) %>%
#  select(-ngram)

n <- NROW(ngram_freq3)

ngram_freq3a <- ngram_freq3[1:12000000,]
saveRDS(ngram_freq3a, "./ngram_freq3a.RDS")
rm(ngram_freq3a)
ngram_freq3b <- ngram_freq3[12000001:n,]
saveRDS(ngram_freq3b, "./ngram_freq3b.RDS")
rm(ngram_freq3b)
ngram_freq5c <- ngram_freq5[20000001:n,]
saveRDS(ngram_freq5c, "./ngram_freq5c.RDS")
rm(ngram_freq5)

ngram_freq1c <- ngram_freq1b[7000001:n,]
saveRDS(ngram_freq1c, "./ngram_freq1c.RDS")
rm(ngram_freq1c)
ngram_freq1b <- ngram_freq1b[2:7000001,]
saveRDS(ngram_freq1b, "./ngram_freq1b.RDS")
rm(ngram_freq1b)

tic("set Dt")
ngram_info_DT1 <- setDT(ngram_freq1)
toc()
tic("pred")
ngram_info_DT1[, pred := word(ngram, -1)] 
toc()
tic("ngram1")
ngram_info_DT1[, ngram_1 := str_replace(ngram, paste0(" ",pred, "$"),"")]
toc()
tic("remove col")
ngram_info_DT1[, ngram := NULL]
toc()
saveRDS(ngram_info_DT1, "./DATA/ngram_info_DT1.RDS")

doc_feat_matrix3 <- readRDS("./DATA/doc_feat_matrix3.RDS")
ngram_freq3 <- textstat_frequency(doc_feat_matrix3) %>%
  select(ngram = feature, freq = frequency)
saveRDS(ngram_freq3, "./ngram_freq3.RDS")
rm(ngram_freq3)
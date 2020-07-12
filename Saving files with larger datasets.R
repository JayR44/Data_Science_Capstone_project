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

ngram_freq3bi <- readRDS("./ngram_freq3bi.RDS")
tic("set Dt")
ngram_info_DT1 <- setDT(ngram_freq3bi)
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
saveRDS(ngram_info_DT1, "./DATA/ngram_info_DT_3bi.RDS")
rm(ngram_info_DT1)
rm(ngram_freq3bi)

##STILL NEED TO DO RUNS FOR 4a AND 4b!!!!

ngram_freq3a <- readRDS("./ngram_freq3a.RDS")
create_data_table(ngram_freq3a, "ngram_freq3a")
rm(ngram_freq3a)

ngram_freq1a <- readRDS("./ngram_freq1a.RDS")
create_data_table(ngram_freq1a, "ngram_freq1a")
rm(ngram_freq1a)

ngram_freq1b <- readRDS("./ngram_freq1b.RDS")
create_data_table(ngram_freq1b, "ngram_freq1b")
rm(ngram_freq1b)

ngram_freq1c <- readRDS("./ngram_freq1c.RDS")
create_data_table(ngram_freq1c, "ngram_freq1c")
rm(ngram_freq1c)

ngram_freq2a <- readRDS("./ngram_freq2a.RDS")
create_data_table(ngram_freq2a, "ngram_freq2a")
rm(ngram_freq2a)

ngram_freq2b <- readRDS("./ngram_freq2b.RDS")
create_data_table(ngram_freq2b, "ngram_freq2b")
rm(ngram_freq2b)

ngram_freq5a <- readRDS("./ngram_freq5a.RDS")
create_data_table(ngram_freq5a, "ngram_freq5a")
rm(ngram_freq5a)

ngram_freq5b <- readRDS("./ngram_freq5b.RDS")
create_data_table(ngram_freq5b, "ngram_freq5b")
rm(ngram_freq5b)

ngram_freq5c <- readRDS("./ngram_freq5c.RDS")
create_data_table(ngram_freq5c, "ngram_freq5c")
rm(ngram_freq5c)

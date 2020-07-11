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

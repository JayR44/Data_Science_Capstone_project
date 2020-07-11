library(tidyverse)
library(quanteda)
library(tm)
library(data.table)

sample_file <- readRDS("./DATA/sample_1000_to_use.RDS")

toks <- tokens(sample_file)

toks_ngram <- tokens_ngrams(toks, n = 2:5, concatenator = " ")

doc_feat_matrix <- dfm(toks_ngram)

ngram_freq <- textstat_frequency(doc_feat_matrix) %>%
  select(ngram = feature, freq = frequency)

ngram_datatable <- setDT(ngram_freq)

ngram_info <- ngram_datatable %>%
  mutate(pred = word(ngram, -1),
         ngram_1 = str_replace(ngram, paste0(" ",pred, "$"),"")) %>%
  select(-ngram)

head(ngram_info)


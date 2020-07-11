library(tidyverse)
library(quanteda)
library(tictoc)

full_file <- readRDS("./DATA/combined_files_to_use.RDS")

#toks_full <- tokens(full_file)
#saveRDS(toks_full, "./DATA/Full tokens list.RDS")

n <- length(toks_full)
#toks1 <- toks_full[1:2000000]
#saveRDS(toks1, "./toks1.RDS")
#toks2 <- toks_full[2000001:2500000]
#saveRDS(toks2, "./toks2.RDS")
#toks3 <- toks_full[2500001:n]
#saveRDS(toks3, "./toks3.RDS")
#comb <- c(toks1, toks2, toks3)

toks_full <- readRDS("./DATA/full tokens list.RDS")
n <- length(toks_full)

#toks_full_ngram <- tokens_ngrams(toks_full, n = 2:5, concatenator = " ")
saveRDS(toks_full_ngram, "./DATA/Full ngram list.RDS")

#Divide toks_full into subsets
toks_full1 <- toks_full[1:1000000]

tic("generating ngrams for 1000000 tokens")
toks_full_ngram1 <- tokens_ngrams(toks_full1, n = 2:5, concatenator = " ")
toc()
saveRDS(toks_full_ngram1, "./DATA/toks_full_ngram1.RDS")

toks_try <- toks_full[1:5000]
tic("test")
toks_ngram <- tokens_ngrams(toks_try, n = 2:5, concatenator = " ")
toc()
saveRDS(toks_ngram, "./DATA/toks_test.RDS")


toks_full5 <- toks_full[3000001:n]
tic("generating ngrams")
toks_full_ngram5 <- tokens_ngrams(toks_full5, n = 2:5, concatenator = " ")
toc()
saveRDS(toks_full_ngram5, "./DATA/toks_full_ngram5.RDS")

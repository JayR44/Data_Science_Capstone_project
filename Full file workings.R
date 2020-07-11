library(tidyverse)
library(quanteda)

full_file <- readRDS("./DATA/combined_files_to_use.RDS")

toks_full <- tokens(full_file)
saveRDS(toks_full, "./DATA/Full tokens list.RDS")

n <- length(toks_full)
toks1 <- toks_full[1:2000000]
saveRDS(toks1, "./toks1.RDS")
toks2 <- toks_full[2000001:2500000]
saveRDS(toks2, "./toks2.RDS")
toks3 <- toks_full[2500001:n]
saveRDS(toks3, "./toks3.RDS")

toks_full_ngram <- tokens_ngrams(toks_full, n = 2:5)
saveRDS(toks_full_ngram, "./DATA/Full ngram list.RDS")

toks_full[1:500]

comb <- c(toks1, toks2, toks3)

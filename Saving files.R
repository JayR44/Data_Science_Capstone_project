library(tidyverse)
library(quanteda)
library(tm)
library(data.table)
library(textclean)
library(ngram)
library(tictoc)

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

sample_file <- readRDS("./DATA/sample_1000_to_use.RDS")

#Generate tokens
toks <- tokens(sample_file)

#Generate ngrams
toks_ngram <- tokens_ngrams(toks, n = 2:5, concatenator = " ")

#Create document feature matrix
doc_feat_matrix <- dfm(toks_ngram)


tic("datatables")
#Obtain frequencies of each ngram
ngram_freq <- textstat_frequency(doc_feat_matrix) %>%
  select(ngram = feature, freq = frequency)

ngram_info_DT <- setDT(ngram_freq)
ngram_info_DT[, pred := word(ngram, -1)] 
ngram_info_DT[, ngram_1 := str_replace(ngram, paste0(" ",pred, "$"),"")]
ngram_info_DT[, ngram := NULL]
toc()

tic("dataframes")
ngram_freq <- textstat_frequency(doc_feat_matrix) %>%
  select(ngram = feature, freq = frequency)
ngram_info <- ngram_freq %>%
  mutate(pred = word(ngram, -1),
         ngram_1 = str_replace(ngram, paste0(" ",pred, "$"),"")) %>%
  select(-ngram)
toc()

#Convert to datatable
ngram_table <- setDT(ngram_info)

head(ngram_table)
###############

#Split toks_full into 5:
#- 1:1000000
#- 1000001:2000000
#- 2000001:2500000
#- 2500001:3000000
#- 3000001:length(toks_full)

toks_full <- readRDS("./DATA/full tokens list.RDS")
n <- length(toks_full)

#toks_full4 <- toks_full[2500001:3000000]
#tic("test")
#toks_full_ngram4 <- tokens_ngrams(toks_full4, n = 2:5, concatenator = " ")
#toc()
#saveRDS(toks_full_ngram4, "./DATA/toks_full_ngram4.RDS")

#Combine all tokens


n <- length(toks_full_ngram4)

toks_full_ngram4a <- toks_full_ngram4[1:250000]
saveRDS(toks_full_ngram4a, "./toks_full_ngram4a.RDS")
rm(toks_full_ngram4a)
toks_full_ngram4b <- toks_full_ngram4[250001:n]
saveRDS(toks_full_ngram4b, "./toks_full_ngram4b.RDS")
rm(toks_full_ngram4b)

toks_full_ngram4a <- readRDS("./DATA/toks_full_ngram4a.RDS")
tic("produce dfm")
doc_feat_matrix4a <- dfm(toks_full_ngram4a)
toc()
saveRDS(doc_feat_matrix4a, "./DATA/doc_feat_matrix4a.RDS")
rm(toks_full_ngram4a)
rm(doc_feat_matrix4a)

toks_full_ngram4b <- readRDS("./DATA/toks_full_ngram4b.RDS")
tic("produce dfm")
doc_feat_matrix4b <- dfm(toks_full_ngram4b)
toc()
saveRDS(doc_feat_matrix4b, "./DATA/doc_feat_matrix4b.RDS")
rm(toks_full_ngram4b)
rm(doc_feat_matrix4b)

ngram_freq2 <- textstat_frequency(doc_feat_matrix2) %>%
  select(ngram = feature, freq = frequency)
saveRDS(ngram_freq2, "./DATA/ngram_freq2.RDS")



ngram_freq2 <- readRDS("./DATA/ngram_freq2.RDS")
n <- NROW(ngram_freq2)

ngram_freq2a <- ngram_freq2[1:12000000,]
saveRDS(ngram_freq2a, "./ngram_freq2a.RDS")
rm(ngram_freq2a)
ngram_freq2b <- ngram_freq2[12000001:n,]
saveRDS(ngram_freq2b, "./ngram_freq2b.RDS")
rm(ngram_freq2b)

ngram_info5 <- ngram_freq5 %>%
  mutate(pred = word(ngram, -1),
         ngram_1 = str_replace(ngram, paste0(" ",pred, "$"),"")) %>%
  select(-ngram)
saveRDS(ngram_info5, "./DATA/ngram_info5.RDS")

#ngram_table5 <- setDT(ngram_info5)
#saveRDS(ngram_table5, "./DATA/ngram_table5.RDS")


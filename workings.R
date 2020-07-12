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

ngram_freq1a_DT <- readRDS("./datatables/ngram_freq1a1.RDS")
n <- NROW(ngram_freq1a_DT)

ngram_freq1a_DT %>%
  group_by(pred, ngram_1) %>%
  count()

ngram_freq1a_DT_t1 <- ngram_freq1a_DT[1:5,]
ngram_freq1a_DT_t2 <-ngram_freq1a_DT[1:5,]
ngram_freq1a_DT_t2 <- ngram_freq1a_DT_t2[freq := freq + 1]

z <- merge(ngram_freq1a_DT_t1, ngram_freq1a_DT_t2, all = T)
z <- bind_rows(ngram_freq1a_DT_t1, ngram_freq1a_DT_t2)

q <- z[, .(freq = sum(freq)), by = list(pred, ngram_1)] ; q

myfiles <- list.files("./datatables/", pattern = "*RDS")
subfiles1 <- myfiles[str_detect(myfiles, "freq1")]
l <- list()

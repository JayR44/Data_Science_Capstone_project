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

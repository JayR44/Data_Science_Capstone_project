library(ff)
library(ffbase)
library(data.table)
library(tidyverse)

options(ffmaxbytes = min(getOption("ffmaxbytes"),.Machine$integer.max * 12))
options(ffbatchbytes = 84882227) 

filepath <- "./Word_Prediction/datatables_min.csv"

ngram_table <- read.csv.ffdf(file = filepath)
class(ngram_table)
#81802659

#system.time(ngram_DT <- fread(filepath, header = TRUE, nrows = 10000000, colClasses = c("character", "character", "numeric")))

system.time(ngram_DT_full <- fread(filepath, header = TRUE, colClasses = c("character", "character", "numeric")))


system.time(ngram_DT_full <- fread(filepath, header = TRUE, nrows = 81802659, colClasses = c("character", "character", "numeric")))

gc(reset = T)
gc()

#system.time(ngram_DT <- fread(filepath, header = TRUE, nrows = 1, colClasses = c("character", "character", "numeric")))

system.time(ngram_DT_ff <- read.table.ffdf(file = filepath, header = TRUE, nrows = 10))
system.time(ngram_DT_ff <- read.table.ffdf(file = filepath, sep = ",", header = TRUE, nrows = 1000000, first.rows = 10, next.rows = 1000000, colClasses = c("factor", "factor", "numeric"), stringsAsFactors = FALSE))

system.time(test <- read.csv.sql(file = "./Word_Prediction/datatables_min.csv", header = TRUE, sep = ",", colClasses = c("character", "character", "numeric"), nrows = 1))

phrase <- "my hero as you"

system.time(ngram_table <- read.table.ffdf(file = "./Word_Prediction/datatables_min.csv", sep = ",",header = TRUE, first.row = 10,colClasses = c("factor", "factor", "numeric")))
#user  system elapsed 
#2736.04   27.10 2813.81 

system.time(ngram_table <- read.table.ffdf(file = "./Word_Prediction/datatables_min.csv", sep = ",",header = TRUE, nrows = 10000000, first.row = 10,colClasses = c("factor", "factor", "numeric")))
#9:17

ind <- ffwhich(ngram_DT_ff, grepl("you", ngram_1))
ind <- ffwhich(ngram_DT_ff, grepl(paste0(phrase,"$"), ngram_1))
ngram_DT_ff[ind,]
ngram_DT_ff$pred <- as.character.ff(ngram_DT_ff$pred)
as.data.table(ngram_DT_ff)

x <- paste0("select * from file where Species like ", "'%set%","sa'")
iris2 <- read.csv.sql("iris.csv", sql = paste0("select * from file where Species like ", "'v%'"))
iris3 <- read.csv.sql("iris.csv", sql = paste0("select * from file where Species like ", "'%setosa'"))
con(iris3)
gc()

iris2 <- read.csv.sql("iris.csv", sql = paste0("select * from file where Species REGEXP 'setsoa'"))

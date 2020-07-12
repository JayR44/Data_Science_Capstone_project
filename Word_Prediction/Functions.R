library(textclean)
library(tm)
library(data.table)

input_adj <- function(input){
  
  #Adjust input
  phrase <- input %>%
    tolower() %>%
    replace_contraction() %>%
    str_replace_all("haven't", "have not") %>%
    str_replace_all("hadn't", "had not") %>%
    removePunctuation()
  
  m <- str_count(phrase, " ") + 1; m
  q <- min(m, 5)
  phrase_input <- paste(word(phrase,-q:-1), collapse = " "); phrase
  
  return(phrase_input)
}

predict_word <- function(table1, table2, table3, table4, phrase){
  
  ind4 <- table4[grep(paste0(" ",phrase,"$"), ngram_1)]
  ind3 <- table3[grep(paste0(" ",phrase,"$"), ngram_1)]
  ind2 <- table2[grep(paste0(" ",phrase,"$"), ngram_1)]
  ind1 <- table1[grep(paste0(" ",phrase,"$"), ngram_1)]
  
  
  loop <- 1
  len_phrase <- str_count(phrase, " ") + 1;
  print(len_phrase)
  
  while(NROW(ind1) + NROW(ind2) + NROW(ind3) + NROW(ind4) == 0 ){
    
    phrase <- str_replace(phrase, paste0("^", word(phrase,1), " "), "")
    print(phrase)
    
    ind4 <- table4[grep(paste0(" ",phrase,"$"), ngram_1)]
    ind3 <- table3[grep(paste0(" ",phrase,"$"), ngram_1)]
    ind2 <- table2[grep(paste0(" ",phrase,"$"), ngram_1)]
    ind1 <- table1[grep(paste0(" ",phrase,"$"), ngram_1)]
    
    loop <- loop + 1
    
    if(loop == len_phrase){
      
      break
      
    }
    
  }
  
  if(NROW(ind1) + NROW(ind2) + NROW(ind3) + NROW(ind4) == 0){
    
    pred_word <- "the"
    
  } else {
  
     if(NROW(ind4) > 0){
         options <- ind4 
  
     } else if (NROW(ind3) > 0){
         options <- ind3 
         
     } else if (NROW(ind2) > 0){
         options <- ind2
       
     } else {
         options <- ind1 
    
     }
    
    options <- options[, . (freq = sum(freq)), by = pred]
    options <- options[order(-freq)]
    
    #pred_word <- options
    pred_word <- options[1,1] %>% pull()
       
  }
  
  print(ind1)
  print(ind2)
  print(ind3)
  print(ind4)
  
  return(pred_word)
  
}

table_1 <- NULL
table_2 <- NULL
table_3 <- NULL
table_4 <- NULL

read_tables <- function(session, table_1, table_2, table_3, table_4){
  
  progress <- Progress$new(session)
  progress$set(value = 0, message = "Loading data")
  
  table_1 <<- readRDS(".\\data\\datatables_min1.RDS")
  progress$set(value = 0.3, message = "Still loading data")
  
  table_2 <<- readRDS(".\\data\\datatables_min2.RDS")
  progress$set(value = 0.6, message = "Still loading data. Thanks for waiting!")
  
  table_3 <<- readRDS(".\\data\\datatables_min3.RDS")
  progress$set(value = 0.9, message = "Still loading data. Nearly there!")
  
  table_4 <<- readRDS(".\\data\\datatables_min4.RDS")
  progress$set(value = 1, message = "Not long to go now!")
  
  progress$close
  
}

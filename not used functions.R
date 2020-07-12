create_data_table <- function(data, string){
  
  n <- NROW(data)
  data1 <- data[1:signif(n/2),]
  data2 <- data[signif(n/2) + 1: n,]
  
  tic("DT")
  ngram_info_DT1 <- setDT(data1)
  print(toc())
  tic("pred")
  ngram_info_DT1[, pred := word(ngram, -1)] 
  print(toc())
  tic("ngram1")
  ngram_info_DT1[, ngram_1 := str_replace(ngram, paste0(" ",pred, "$"),"")]
  print(toc())
  tic("rm")
  ngram_info_DT1[, ngram := NULL]
  print(toc())
  saveRDS(ngram_info_DT1, paste0("./datatables/",string,"1.RDS"))
  rm(ngram_info_DT1)
  
  tic("DT")
  ngram_info_DT1 <- setDT(data2)
  print(toc())
  tic("pred")
  ngram_info_DT1[, pred := word(ngram, -1)] 
  print(toc())
  tic("ngram1")
  ngram_info_DT1[, ngram_1 := str_replace(ngram, paste0(" ",pred, "$"),"")]
  print(toc())
  tic("rm")
  ngram_info_DT1[, ngram := NULL]
  print(toc())
  saveRDS(ngram_info_DT1, paste0("./datatables/",string,"2.RDS"))
  rm(ngram_info_DT1)
  
}

clean_text <- function(text){
  
  text %>%
    tolower() %>%
    replace_incomplete(replacement = " ") %>%
    replace_contraction() %>%
    str_replace_all("haven't", "have not") %>%
    str_replace_all("hadn't", "had not") %>%
    replace_word_elongation() %>%
    replace_internet_slang() %>%
    replace_url() %>%
    replace_email() %>%
    replace_hash() %>%
    replace_non_ascii() %>%
    str_replace_all(":\\)|;\\)", "") %>%
    str_replace_all("<3", "") %>%
    str_replace_all("^:+ ", "") %>%
    stripWhitespace() %>%
    strip()
}


predict_word <- function(ngram_table, phrase){
  
  #Given a sentence, the model will predict the next word
  
  #Obtain lines from the data table with the last few words of ngram_1 matching the phrase
  sub_lines <- ngram_table[grep(paste0(" ", phrase,"$"), ngram_1)]
  
  loop <- 1
  len_phrase <- str_count(phrase, " ");
  
  #If there are no matches
  while(NROW(sub_lines) == 0) {
    
    #Remove the last word from the phrase
    phrase <- str_replace(phrase, paste0("^", word(phrase,1), " "), "")
    sub_lines <- ngram_table[grep(paste0(" ", phrase,"$"), ngram_1)]
    
    loop <- loop + 1
    
    #Stop if the loop equals the length of the phrase
    if(loop == len_phrase){
      break
    }
    
  }
  
  if(NROW(sub_lines) == 0){
    
    options <- data.table(pred = "the",
                          tot_freq = 1)
    
  } else {
    
    # options <- sub_lines %>%
    #    group_by(pred) %>%   #group_by(pred, ngram_1) %>%    whould show most common next world but not necessarily specific to the phrase
    #    summarise(tot_freq = sum(freq)) %>%
    #    ungroup() %>%
    #    arrange(desc(tot_freq))
    
    options <- sub_lines[, . (freq = sum(freq)), by = pred]
    options <- options[order(-freq)]
    
  }
  
  return(options)   
  
}

predict_word2 <- function(ngram_table, phrase){
  
  #Given a sentence, the model will predict the next word
  
  #Obtain lines from the data table with the last few words of ngram_1 matching the phrase
  sub_lines <- ngram_table[grep(paste0(" ", phrase,"$"), ngram_1)]
  
  loop <- 1
  len_phrase <- str_count(phrase, " ");
  
  #If there are no matches
  while(NROW(sub_lines) == 0) {
    
    #Remove the last word from the phrase
    phrase <- str_replace(phrase, paste0("^", word(phrase,1), " "), "")
    sub_lines <- ngram_table[grep(paste0(" ", phrase,"$"), ngram_1)]
    
    loop <- loop + 1
    
    #Stop if the loop equals the length of the phrase
    if(loop == len_phrase){
      break
    }
    
  }
  
  if(NROW(sub_lines) == 0){
    
    options <- data.table(pred = "the",
                          tot_freq = 1)
    
  } else {
    
    options <- sub_lines %>%
      group_by(pred) %>%   #group_by(pred, ngram_1) %>%    whould show most common next world but not necessarily specific to the phrase
      summarise(tot_freq = sum(freq)) %>%
      ungroup() %>%
      arrange(desc(tot_freq))
    
  }
  
  return(options)    #return(predicted_word)
  
}

predict_word <- function(table1, table2, table3, phrase){
  
  ind1 <- table1[grep(paste0("^",phrase,"$"), ngram_1)]
  ind2 <- table2[grep(paste0("^",phrase,"$"), ngram_1)]
  ind3 <- table3[grep(paste0("^",phrase,"$"), ngram_1)]
  
  # print(ind1)
  # print(ind2)
  # print(ind3)
  
  loop <- 1
  len_phrase <- str_count(phrase, " ") + 1;
  
  while(NROW(ind1) + NROW(ind2) + NROW(ind3) == 0 ){
    
    phrase <- str_replace(phrase, paste0("^", word(phrase,1), " "), "")
    # print(phrase)
    
    ind1 <- table1[grep(paste0("^",phrase,"$"), ngram_1)]
    ind2 <- table2[grep(paste0("^",phrase,"$"), ngram_1)]
    ind3 <- table3[grep(paste0("^",phrase,"$"), ngram_1)]
    
    # print(ind1)
    # print(ind2)
    # print(ind3)
    
    loop <- loop + 1
    
    if(loop == len_phrase){
      
      break
      
    }
    
  }
  
  if(NROW(ind1) + NROW(ind2) + NROW(ind3) == 0){
    
    pred_word <- "the"
    
  } else {
    
    if(NROW(ind1) > 0){
      pred_word <- ind1$pred 
      
    } else if (NROW(ind2) > 0){
      pred_word <- ind2$pred 
      
    } else {
      pred_word <- ind3$pred 
      
    }
    
  }
  
  return(pred_word)
  
}

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

input_adj <- function(input){
  
  #Adjust input
  phrase <- input %>%
    tolower() %>%
    replace_contraction() %>%
    str_replace_all("haven't", "have not") %>%
    str_replace_all("hadn't", "had not") %>%
    removePunctuation()
  
  m <- wordcount(phrase); m
  q <- min(m, 5)
  phrase_input <- paste(word(phrase,-q:-1), collapse = " "); phrase
  
  return(phrase_input)
}



predict_word <- function(ngram_table, phrase){
  
  #Given a sentence, the model will predict the next word
  
  #Obtain lines from the data table with the last few words of ngram_1 matching the phrase
  sub_lines <- ngram_table[grep(paste0(" ", phrase,"$"), ngram_1)]
  
  loop <- 1
  len_phrase <- wordcount(phrase);
  
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
    
    stop("No prediction found")
    
  }
  
  options <- sub_lines %>%
    group_by(pred) %>%   #group_by(pred, ngram_1) %>%    whould show most common next world but not necessarily specific to the phrase
    summarise(tot_freq = sum(freq)) %>%
    ungroup() %>%
    arrange(desc(tot_freq))
  
  #predicted_word <- options[1,1] %>% pull()
  
  return(options)    #return(predicted_word)
  
}


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
    str_replace_all(q, "^:+ ", "") %>%
    stripWhitespace()
}

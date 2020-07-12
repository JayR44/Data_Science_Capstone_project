
library(shiny)
library(shinycssloaders)
library(tidyverse)
library(data.table)


source("./Functions.R")

ngram_table <- NULL

#ngram_table <- data.table::fread("data\\datatables_min4.csv")
#ngram_table <- readRDS("data\\datatables_min4.RDS")

# Define server logic required
shinyServer(function(input, output) {
    
    if(is.null(ngram_table)){
        
        ngram_table <- data.table::fread("data\\datatables_min4.csv")
    }

    words <- reactive({
        
        #Adjust input
        phrase_input <- input_adj(input$txt)
        
    })
    
    freqs <- reactive({
        
        #Produce table of possible predictions
        predict_word(ngram_table, words())
        
    })
    
    output$phrase <- renderText({
        
        paste(input$txt, "...")
    })
    
    output$word_options <- renderDataTable({

        freqs()
        
    })
    
    output$table <- renderDataTable({
        
        "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        
    })
    
    output$predicted_word <- renderText({
        
        #Select word with highest frequency
        pred_word <- freqs()
        paste("...",pred_word[1,1] %>% pull())
        
    })

})

library(shiny)
library(data.table)
library(tm)
library(textclean)

source("../Functions.R")
ngram_table <- readRDS("data\\sample_100000_table.RDS")

# Define server logic required
shinyServer(function(input, output) {

    f <- reactive({
        
        #Adjust input
        phrase_input <- input_adj(input$txt)
        
    })
    
    output$word_options <- renderDataTable({
        
        #Import data table - need to solve this!
       # ngram_table <- readRDS("../sample_100000_table.RDS")
        predict_word(ngram_table, f())
        
    })
    
    output$phrase <- renderText({
        #Select word with highest frequency
        words <- f()
        words
        
    })

})

#words <- readline(prompt = "Enter phrase")
#words <- "Hello world"
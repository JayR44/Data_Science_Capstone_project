
library(shiny)
library(shinycssloaders)
library(tidyverse)


source("./Functions.R")

ngram_table <- NULL

# Define server logic required
shinyServer(function(input, output, session) {
    
    if(is.null(ngram_table)){
        
        
        progress <- Progress$new(session)
        progress$set(value = 0, message = "Loading data")
        
        ngram_table <<- read.table.ffdf(file = "datatables_min.csv", sep = ",",
                                       header = TRUE, nrows = 1000000,
                                       first.row = 1000, next.rows = 100000,
                                      colClasses = c("factor", "factor", "numeric"))
        
        #load.ffdf("../ffdb")
        #system.time(load.ffdf("data"))
       # ngram_table <<- ngram_ffdf
        
        progress$set(value = 1, message = "Data loaded")
        
        progress$close
        
       #load_ngram_table(session, ngram_table)
       # print(ngram_table)
        #read_tables(session, table_1, table_2, table_3, table_4)
    }

    words <- reactive({
        
        #Adjust input
        phrase_input <- input_adj(input$txt)
        print(phrase_input)
        
    })
    
    freqs <- reactive({
        
        #Predict word
        predict_word(ngram_table, words())
        
    })
    
    output$phrase <- renderText({
        
        paste(input$txt, "...")
    })
    
    
    output$predicted_word <- renderText({
        
        #Obtain prediction

        freqs()
        
    })

})
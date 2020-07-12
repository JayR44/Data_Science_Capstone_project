
library(shiny)
library(shinycssloaders)
library(tidyverse)


source("./Functions.R")


# Define server logic required
shinyServer(function(input, output, session) {
    
    if(is.null(table_3)){
        
        read_tables(session, table_1, table_2, table_3, table_4)
    }

    words <- reactive({
        
        #Adjust input
        phrase_input <- input_adj(input$txt)
        
    })
    
    freqs <- reactive({
        
        #Predict word
        predict_word(table_1, table_2, table_3, table_4, words())
        
    })
    
    output$phrase <- renderText({
        
        paste(input$txt, "...")
    })
    
    
    output$predicted_word <- renderText({
        
        #Obtain prediction

        freqs()
        
    })

})

# shrink data.table to be unique n-grams
# add graph showing top 5 most likely suggestions + freqs
#

library(shiny)
library(tidyverse)
library(data.table)

source("../Functions.R")

# Define UI for application that predicts the next word of a phrase
shinyUI(fluidPage(

    # Application title
    titlePanel("Word Prediction App"),

    # Sidebar with phrase input
    sidebarLayout(
        sidebarPanel(
            textInput("txt", 'Input words', value = "Enter words"),
            submitButton("Predict next word")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           #plotOutput("distPlot"),
           # h3(textOutput("predicted_word"))
            textOutput("phrase")
            dataTableOutput("word_options")
        )
    )
))

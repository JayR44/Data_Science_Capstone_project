
library(shiny)
library(shinycssloaders)
library(tidyverse)

# Define UI for application that predicts the next word of a phrase
shinyUI(fluidPage(

    # Application title
    titlePanel("Word Prediction App"),

    # Sidebar with phrase input
    sidebarLayout(
        sidebarPanel(
            textInput("txt", 'Enter words', value = "Input here"),
            submitButton("Predict next word")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h3(textOutput("phrase")),
            br(),
            h2(em(textOutput("predicted_word") %>% withSpinner())),
            hr(),
            br(),
            dataTableOutput("table") %>%
                withSpinner(type = 4, color = "#0275D8"),
        )
    )
))

library(shiny)
source('a.function.R')

shinyUI(fluidPage(
  a.function(),
  sidebarLayout(
    sidebarPanel(
       sliderInput("bins",
                   "Number of bins:",
                   min = 1,
                   max = 50,
                   value = 30)
    ),
    mainPanel(
       plotOutput("distPlot")
    )
  )
))

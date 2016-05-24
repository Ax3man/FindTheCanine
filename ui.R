library(shiny)

shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      wellPanel(
        textInput('locator', 'Your name'),
        selectInput('species', 'Species', c('Dogs', 'Wolves')),
        selectInput('year', 'Year', c('2014', '2015', '2016'))
      )
    ),
    mainPanel(
      fluidRow(
        wellPanel(
          radioButtons('canine', 'Selecting...', c('Janis', 'Dog2'), inline = TRUE),
          actionButton('save', 'Save locations!', icon = icon('floppy-o'))
        )
      ),
      fluidRow(  
        plotOutput("distPlot", click = 'plot_click', '100%')
      )
    )
) ) )


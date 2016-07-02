library(shiny)

shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      wellPanel(
        actionButton('dir_select', 'Select folder...'),
        textInput('observer', 'Your name'),
        selectInput('species', 'Species', c('Dogs', 'Wolves')),
        selectInput('year', 'Year', c('2014', '2015', '2016'))
      ),
      wellPanel(
        h3('Navigation'),
        actionButton('5back', '5 min back', icon = icon('fast-backward')),
        actionButton('1back', '1 min back', icon = icon('backward')),
        actionButton('1forward', '1 min forward', icon = icon('forward')),
        actionButton('5forward', '5 min forward', icon = icon('fast-forward'))
      ),
      wellPanel(
        h3('Image adjustment'),
        sliderInput('brightness', 'Brightness', 0, 2, 1, 0.05),
        sliderInput('contrast', 'Contrast', 0, 2, 1, 0.05)
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
        plotOutput("distPlot", click = 'plot_click', '1500px', '1500px')
      )#,
      #fluidRow(
      #  tableOutput('printAvailable')
      #)
    )
  ) ) )

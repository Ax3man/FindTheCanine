library(shiny)

shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      h1('FindTheCanine'),
      wellPanel(
        actionButton('dir_select', 'Select folder...'),
        textInput('observer', 'Your name'),
        selectInput('species', 'Species', c('Dogs', 'Wolves')),
        selectInput('year', 'Year', c('2014', '2015', '2016'))
      ),
      wellPanel(
        h3('Navigation'),
        actionButton('randomize', 'Go to random time.', 
                                       icon = icon('random')),
        actionButton('5back', '5 min back', 
                     icon = icon('fast-backward')),
        actionButton('1back', '1 min back', 
                     icon = icon('backward')),
        actionButton('1forward', '1 min forward', 
                     icon = icon('forward')),
        actionButton('5forward', '5 min forward', 
                     icon = icon('fast-forward'))
      ),
      wellPanel(
        h3('Image adjustment'),
        sliderInput('brightness', 'Brightness', 1, 2, 1, 0.05),
        sliderInput('contrast', 'Contrast', 1, 2, 1, 0.05)
      ),
      width = 3
    ),
    mainPanel(
      fluidRow(
        wellPanel(
          uiOutput('pupSelector'),
          actionButton('save', 'Save locations!', icon = icon('floppy-o'))
        )
      ),
      fluidRow(
        plotOutput("distPlot", click = 'plot_click', '1200px', '800px')
      )#,
      #fluidRow(
      #  tableOutput('printAvailable')
      #)
    )
  ) ) )

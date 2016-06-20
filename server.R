#### Setup and packages --------------------------------------------------------
library(shiny)
if (!require(imager)) {
  install.packages('imager')
}
if (!require(dplyr)) {
  install.packages('dplyr')
}
if (!require(googlesheets)) {
  install.packages('googlesheets')
}

#### Image prep and build a table ----------------------------------------------

source('data_prep.R')
source('image_adjustments.R')

gs <- gs_key('1R9FLU0xr9uNC79LCqzu2axQ4McPMjZWV0u96ap2kDIc', lookup = TRUE, 
             verbose = FALSE)
dat <- gs_read(gs, 1, verbose = FALSE)
to_check <- filter(dat, !checked)

shinyServer(function(input, output) {
  # Data prep
  reac <- reactiveValues(available = NULL, click1 = NULL, combined = NULL, 
                         chosen_time = NULL, dir = NULL,
                         pup1 = NULL, pup2 = NULL, pup3 = NULL,
                         pup4 = NULL, pup5 = NULL, pup6 = NULL)
  available <- reactive(find_pics(reac$dir, input$year, input$species))
  
  observeEvent(input$dir_select, {
    reac$dir <- choose.dir()
  } )
  
  # Record and correctly assign plot clicks
  observeEvent(input$plot_click, {
    if (is.null(v$click1)) {
      v$click1 <- input$plot_click
    } else {
      reac[[input$canine]] <- c(head_x = reac$click1$x,
                                head_y = reac$click1$y,
                                tail_x = input$plot_click$x,
                                tail_x = input$plot_click$y)
      v$click1 <- NULL
    }
  } )
  
  observeEvent(input$save, {
    gs_add_row(gs, 1,
               c(input$observer, Sys.time(), sample(1000, 1),
                 reac$Janis$x, reac$Janis$y, reac$Dog2$x, reac$Dog2$y))
    for (i in paste0('pup', 1:6)) {
      reac[[i]] <- NULL
    }
  } )
  
  output$distPlot <- renderPlot( {
    combined <- reactive(combine_imgs(available(), reac$chosen_time, 
                                      input$year, input$species))
    plot(adjust_image(combined(), input$brightness, input$contrast), 
         axes = FALSE, main = 'The room', asp = 1)
    for (i in paste0('pup', 1:6)) {
      if (!is.null(reac[[i]]))
        arrows(reac[[i]]$tail_x, reac[[i]]$tail_y, reac[[i]]$head_x, 
               reac[[i]]$head_y, cex = 2, pch = 16, col = 2)
    }
  } )
} )


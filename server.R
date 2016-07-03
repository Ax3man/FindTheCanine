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

# Hard code pup names
pup_names <- list('2014' = list(Dogs = c(a = 'pup1', b = 'pup2', c = 'pup3',
                                         d = 'pup4', e = 'pup5', f = 'pup6',
                                         human = 'human'), 
                                Wolves = c(a = 'pup1', b = 'pup2', c = 'pup3',
                                           d = 'pup4', e = 'pup5', f = 'pup6',
                                           human = 'human')),
                  '2015' = list(Dogs = c(a = 'pup1', b = 'pup2', c = 'pup3',
                                         d = 'pup4', e = 'pup5', f = 'pup6',
                                         human = 'human'),
                                Wolves = c(a = 'pup1', b = 'pup2', c = 'pup3',
                                           d = 'pup4', e = 'pup5', f = 'pup6',
                                           human = 'human')),
                  '2016' = list(Dogs = c(a = 'pup1', b = 'pup2', c = 'pup3',
                                         d = 'pup4', e = 'pup5', f = 'pup6',
                                         human = 'human'),
                                Wolves = c(A = 'pup1', b = 'pup2', c = 'pup3',
                                           d = 'pup4', e = 'pup5', f = 'pup6',
                                           human = 'human')))
shinyServer(function(input, output) {
  #### Data prep ---------------------------------------------------------------
  gs <- gs_key('1R9FLU0xr9uNC79LCqzu2axQ4McPMjZWV0u96ap2kDIc', lookup = TRUE, 
               verbose = FALSE)
  gtable <- load_gtable(gs, input$year, input$species)
  
  q <- c(head_x = NA, head_y = NA, tail_x = NA, tail_y = NA)
  reac <- reactiveValues(available = NULL, click1 = NULL, combined = NULL, 
                         chosen_time = NULL, dir = NULL,
                         pup1 = q, pup2 = q, pup3 = q, pup4 = q, pup5 = q, 
                         pup6 = q, human = q)
  
  observeEvent(input$dir_select, {
    reac$dir <- choose.dir()
  } )
  
  available <- reactive(find_pics(reac$dir, input$year, input$species))
  
  clear_clicks <- function() {
    q <- c(head_x = NA, head_y = NA, tail_x = NA, tail_y = NA)
    reac$pup1 <- q; reac$pup2 <- q; reac$pup3 <- q; reac$pup4 <- q
    reac$pup5 <- q; reac$pup6 <- q; reac$human <- q; reac$click1 <- NULL
  }
  
  #### Create dynamic UI -------------------------------------------------------
  output$pupSelector <- renderUI( {
    radioButtons('canine', 'Selecting...', inline = TRUE,
                 pup_names[[input$year]][[input$species]])
  })
  
  #### Time navigation ---------------------------------------------------------
  observeEvent(input$randomize, {
    reac$chosen_time <- pick_new_time(available(), 'random')
    clear_clicks()
  } )
  observeEvent(input$`1forward`, {
    reac$chosen_time <- as.character(as.numeric(reac$chosen_time) + 1)
    clear_clicks()
  } )
  observeEvent(input$`1back`, {
    reac$chosen_time <- as.character(as.numeric(reac$chosen_time) - 1)
    clear_clicks()
  } )
  observeEvent(input$`5forward`, {
    reac$chosen_time <- as.character(as.numeric(reac$chosen_time) + 5)
    clear_clicks()
  } )
  observeEvent(input$`5back`, {
    reac$chosen_time <- as.character(as.numeric(reac$chosen_time) - 5)
    clear_clicks()
  } )
  
  #### Stitch the correct images together and display them in a plot -----------
  output$distPlot <- renderPlot( {
    if (is.null(reac$chosen_time)) {
      plot(1, type = 'n', axes = FALSE, xlab = '', ylab = '')
      text(1, 1, 'Choose a folder and click random. Happy clickin\'!', cex = 2)
    } else {
      combined <- reactive(combine_imgs(available(), reac$chosen_time, 
                                        input$year, input$species))
      par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0))
      plot(adjust_image(combined(), input$brightness, input$contrast), 
           axes = FALSE, main = 'The room', asp = 1)
      for (i in 1:7) {
        p <- c(paste0('pup', 1:6), 'human')[i]
        if (!is.null(reac[[p]])) {
          arrows(reac[[p]]['tail_x'], reac[[p]]['tail_y'], reac[[p]]['head_x'], 
                 reac[[p]]['head_y'], lwd = 3,
                 col = i + 1)
          #if(i == 1) browser()
        }
      }
    }
  } )
  
  #### Record and correctly assign plot clicks ---------------------------------
  observeEvent(input$plot_click, {
    if (is.null(reac$click1)) {
      reac$click1 <- input$plot_click
    } else {
      reac[[input$canine]] <- c(head_x = reac$click1$x,
                                head_y = reac$click1$y,
                                tail_x = input$plot_click$x,
                                tail_y = input$plot_click$y)
      reac$click1 <- NULL
    }
  } )
  
  #### Save clicks to table and find new time ----------------------------------
  observeEvent(input$save, {
    gs_add_row(gs, 1,
               c(input$observer, Sys.time(), input$year, input$species, 
                 reac$chosen_time, reac$pup1, reac$pup2, reac$pup3, reac$pup4,
                 reac$pup5, reac$pup6, reac$human))
    gtable <- load_gtable(gs, input$year, input$species)
    for (i in paste0('pup', 1:6)) {
      reac[[i]] <- NULL
    }
    reac$chosen_time <- pick_new_time(available(), 'max_distance_fast', gtable)
  } )
  
  #DEBUGGING
  #output$printAvailable <- renderTable(head(available()))
} )


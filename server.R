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

barney <- load.image(paths[grep(paste0('barney_', OUT$time_code[1]), files)])
bert <- load.image(paths[grep(paste0('bert_', OUT$time_code[1]), files)])
bettie <- load.image(paths[grep(paste0('bettie_', OUT$time_code[1]), files)])
cookie <- load.image(paths[grep(paste0('cookie_', OUT$time_code[1]), files)])
dino <- load.image(paths[grep(paste0('dino_', OUT$time_code[1]), files)])
ernie <- load.image(paths[grep(paste0('ernie_', OUT$time_code[1]), files)])
fozzie <- load.image(paths[grep(paste0('fozzie_', OUT$time_code[1]), files)])
fred <- load.image(paths[grep(paste0('fred_', OUT$time_code[1]), files)])
snuff <- load.image(paths[grep(paste0('snuff_', OUT$time_code[1]), files)])

combined <- add(list(pad(barney, 640, 'x', 1), pad(snuff, 640, 'x', -1)))

gs <- gs_key('1R9FLU0xr9uNC79LCqzu2axQ4McPMjZWV0u96ap2kDIc', lookup = TRUE, 
             verbose = FALSE)
dat <- gs_read(gs, 1, verbose = FALSE)
to_check <- filter(dat, !checked)

shinyServer(function(input, output) {
  reac <- reactiveValues(Janis = NULL, Dog2 = NULL)
  
  output$distPlot <- renderPlot({
    plot(adjust_image(combined, input$brightness, input$contrast), 
         axes = FALSE, main = 'The room', asp = 1)
    points(reac$Janis$x, reac$Janis$y, cex = 2, pch = 16, col = 2)
    points(reac$Dog2$x, reac$Dog2$y, cex = 2, pch = 16, col = 3)
  } )
  
  observeEvent(input$plot_click, {
    reac[[input$canine]] <- input$plot_click
  } )
  
  observeEvent(input$save, {
    gs_add_row(gs, 1,
               c(input$locator, Sys.time(), sample(1000, 1), TRUE,
                 reac$Janis$x, reac$Janis$y, reac$Dog2$x, reac$Dog2$y))
    reac$Janis <- NULL
    reac$Dog2 <- NULL
  } )
} )


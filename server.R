#### Setup and packages --------------------------------------------------------
library(shiny)
if (!require(imager)) {
  installed.packages('imager')
}
if (!require(dplyr)) {
  installed.packages('dplyr')
}

#### Image prep and build a table ----------------------------------------------

source('data_prep.R')

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
combined %>% imrotate(90) %>% plot

p <- locator(1)
points(p, cex = 6, col = 'red')

shinyServer(function(input, output) {
  output$distPlot <- renderPlot({
    
  })
})


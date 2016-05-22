#### Setup and packages --------------------------------------------------------
library(shiny)
if (!require(imager)) {
  installed.packages('imager')
}
if (!require(dplyr)) {
  installed.packages('dplyr')
}
if (!require(dplyr)) {
  installed.packages('dplyr')
}

#### Image prep and build a table ----------------------------------------------

## Find the images
#folder <- choose.dir()
folder <- 'C:/Users/Wouter/Google Drive/PhD Stockholm/Christina/Puppy social networks/Test pics/Dogs/'
files <- list.files(folder)
files <- files[tools::file_ext(files) == 'jpg']
files <- files[-grep('\\(1\\).jpg', files)]

## Extract their times, so we can see what is there
times <- files %>% 
  strsplit('_') %>% lapply(`[[`, 2) %>% 
  unlist() %>% 
  strsplit('\\.') %>% lapply(`[[`, 1) %>%
  unlist() %>%
  substr(1, 12)
# Get the times of which we have exact 9 pictures (TODO: MAKE SMART TO YEAR ETC)
times <- table(times)[table(times) == 9] %>% names
OUT <- data_frame(year = substr(times, 1, 4),
                  month = substr(times, 5, 6),
                  day = substr(times, 7, 8),
                  hour = substr(times, 9, 10),
                  minute = substr(times, 11, 12),
                  time_code = times, 
                  done = FALSE,
                  pup1_x = NA,
                  pup1_y = NA,
                  pup2_x = NA,
                  pup2_y = NA)

shinyServer(function(input, output) {
  output$distPlot <- renderPlot({
    
  })
})

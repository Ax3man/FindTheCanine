find_pics <- function(folder, year, species) {
  # folder <- 'C:/Users/Wouter/Google Drive/PhD Stockholm/Christina/Puppy social networks/Test pics/Dogs/'
  files <- list.files(folder, recursive = TRUE)
  paths <- list.files(folder, full.names = T)
  
  sel <- files[tools::file_ext(files) == 'jpg']
  sel <- files[-grep('\\(1\\).jpg', sel)]
  paths <- paths[files %in% sel]
  files <- sel
  
  if (year == 2016 & species == 'wolfs') {
    camera_list <- c('bigbird', 'elmo', 'bettie', 'bert', 'bambam', 'cookie',
                     'snuff', 'oscar', 'ernie', 'kermit', 'barney')
  }
  
  ## Extract their times, so we can see what is there
  times <- sel %>% 
    strsplit('_') %>% lapply(`[[`, 2) %>% 
    unlist() %>% 
    strsplit('\\.') %>% lapply(`[[`, 1) %>%
    unlist() %>%
    substr(1, 12)
  
  available_files <- data_frame(time_code = times,
                                year = substr(time_code, 1, 4),
                                month = substr(time_code, 5, 6),
                                day = substr(time_code, 7, 8),
                                hour = substr(time_code, 9, 10),
                                minute = substr(time_code, 11, 12),
                                file = files,
                                path = paths)
  available_files <- available_files %>% 
    group_by(time_code) %>%
    filter(n() == length(camera_list))
  
  return(available_files)
}

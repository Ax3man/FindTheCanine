pick_new_time <- function(available, method, gtable = NULL) {
  if (method == 'random') {
    chosen_time <- sample(unique(available$time_code), 1)
  }
  if (method == 'max_distance') {
    available_times <- parse_date_time(available$time_code, 'ymdhm')
    checked_times <- parse_date_time(gtable$time_code, 'ymdhm')
    dists <- sapply(available_times, function(x) min(abs(x - checked_times)))
    chosen_time <- available$time_code[which.max(dists)]
  }
  if (method == 'max_distance_fast') {
    sel <- sample(1:nrow(available), 100)
    available_times <- parse_date_time(available$time_code[sel], 'ymdhm')
    checked_times <- parse_date_time(gtable$time_code, 'ymdhm')
    dists <- sapply(available_times, function(x) min(abs(x - checked_times)))
    chosen_time <- available$time_code[which.max(dists)]
  }
  return(chosen_time)
}

load_gtable <- function(gs, year, species) {
  gtable <- gs_read(gs, 1, verbose = FALSE)
  filter(gtable, year == year, species == species)
}

find_pics <- function(folder, year, species) {
  if (is.null(folder)) {
    return(NULL)
  }
  # folder <- 'C:/Users/Wouter/Google Drive/PhD Stockholm/Christina/Puppy social networks/Test pics/Dogs/'
  files <- list.files(folder, recursive = TRUE)
  paths <- list.files(folder, recursive = TRUE, full.names = T)
  paths <- paths[seq_along(files)]
  
  sel <- files[tools::file_ext(files) == 'jpg']
  sel <- files[-grep('\\(1\\).jpg', sel)]
  paths <- paths[files %in% sel]
  files <- sel
  
  if (year == '2016' & species == 'Wolves') {
    camera_list <- c('bigbird', 'elmo', 'bettie', 'bert', 'bambam', 'cookie',
                     'snuff', 'oscar', 'ernie', 'kermit', 'barney')
  } else {
    camera_list <- NULL
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

combine_imgs <- function(available, chosen_time, year, species) {
  if (is.null(chosen_time)) {
    return(NULL)
  }
  paths <- filter(available, time_code == chosen_time)$path
  if (year == '2016' & species == 'Wolves') {
    
    par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0))
    bert <- load.image(paths[3]) %>% imrotate(1.5) %>% extract(, 35:480, , ) %>% 
      as.cimg %>% adjust_image(0.9, 1) %>% resize(size_y = 475)
    bettie <- load.image(paths[4]) %>% extract(, 20:350, , ) %>% as.cimg %>% 
      pad(10, 'x', -1) %>% adjust_image(1, 1.1) %>% resize(size_y = 340)
    elmo <- load.image(paths[7]) %>% imrotate(-1) %>% pad(30, 'x', -1) %>% 
      extract(, 20:430, , ) %>% as.cimg %>% adjust_image(1.1)
    bigbird <- load.image(paths[5]) %>% imrotate(1.5) %>% pad(40, 'x', -1) %>% 
      extract(, 1:370, , ) %>% as.cimg
    
    left_col <- imappend(list(bigbird, elmo, bettie, bert), 'y') %>% 
      extract(1:640, , , ) %>% as.cimg
    
    cookie <- load.image(paths[6]) %>% pad(20, 'y', -1) %>% adjust_image(0.82)
    snuff <- load.image(paths[11]) %>% extract(, 165:425, , ) %>% as.cimg
    oscar <- load.image(paths[10]) %>% imrotate(-5) %>% adjust_image(0.82) %>% 
      extract(, 42:370, , ) %>% as.cimg %>% pad(20, 'x', -1)
    ernie <- load.image(paths[8]) %>% pad(40, 'x', -1) %>% adjust_image(0.82)
    
    right_col <- imappend(list(cookie, snuff, oscar, ernie), 'y') %>% 
      extract(180:640, , , ) %>% as.cimg
    #plot(right_col, asp = 1, axes = FALSE)
    
    complete <- imappend(list(left_col, right_col), 'x')
    #plot(complete, asp = 1, axes = FALSE)
    
    # kermit <- load.image(paths[9])
    
    # combined <- parmax(list(
    #   load.image(paths[3]) %>% pad(350, 'x', 1) %>% pad(1100, 'y', -1),
    #   load.image(paths[4]) %>% adjust_image(1.2) %>% pad(350, 'x', 1) %>% 
    #     pad(1100 - 300, 'y', -1) %>% pad(300, 'y', 1),
    #   load.image(paths[7]) %>% adjust_image(1.2) %>% pad(310, 'x', 1) %>% 
    #     pad(40, 'x', -1) %>% pad(1100 - 700, 'y', -1) %>% pad(700, 'y', 1),
    #   load.image(paths[5]) %>% imrotate(1.5) %>% adjust_image(1.2) %>% 
    #     pad(295 - 6, 'x', 1) %>% pad(55 - 6, 'x', -1) %>% 
    #     pad(1100 - 1050 - 16, 'y', -1) %>% pad(1050, 'y', 1),
    #   load.image(paths[6]) %>% pad(350, 'x', -1) %>% pad(1100, 'y', 1)
    #   
    # ))
    # plot(imrotate(combined, 90), asp = 1, axes = FALSE)
  }
  return(complete)
}
  
truncate <- function(x, upper = 1, lower = 0) {
  x[x < lower] <- lower
  x[x > upper] <- upper
  return(x)
}

adjust_image <- function(im, brightness = 1, contrast = 1) {
  if (is.null(im)) {
    return(1:10)
  }
  im <- as.array(im)
  im <- truncate(contrast * (im - 0.5) + 0.5)
  im <- truncate(im * brightness)
  as.cimg(im)
}

combine_imgs <- function(available, chosen_time, year, species) {
  paths <- filter(available, time_code == chosen_time)$path
  if (year == '2016' & species == 'wolfs') {
    
    combined <- imappend(list(
      load.image(paths[3])
    ))
    
    combined <- parmax(list(
      load.image(paths[3]) %>% pad(350, 'x', 1) %>% pad(1200, 'y', -1),
      load.image(paths[4]) %>% adjust_image(1.2) %>% pad(350, 'x', 1) %>% 
        pad(1200 - 300, 'y', -1) %>% pad(300, 'y', 1),
      load.image(paths[5]) %>% adjust_image(1.2) %>% pad(350, 'x', 1) %>% 
        pad(1200, 'y', 1),
      load.image(paths[6]) %>% pad(350, 'x', -1) %>% pad(1200, 'y', 1),
      load.image(paths[7]) %>% adjust_image(1.2) %>% pad(350, 'x', 1) %>% 
        pad(1200 - 850, 'y', -1) %>% pad(850, 'y', 1)
    ))
    plot(combined, asp = 1)

  }
}
  
truncate <- function(x, upper = 1, lower = 0) {
  x[x < lower] <- lower
  x[x > upper] <- upper
  return(x)
}

adjust_image <- function(im, brightness = 1, contrast = 1) {
  im <- as.array(im)
  im <- truncate(contrast * (im - 0.5) + 0.5)
  im <- truncate(im * brightness)
  as.cimg(im)
}

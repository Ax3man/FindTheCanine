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

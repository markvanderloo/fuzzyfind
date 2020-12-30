# readable output from a number of seconds.
humanize <- function(x, color=TRUE){
  x <- as.numeric(x)
  # ms units
  str <-  if (x < 0.1){ 
    trimws(sprintf("%4.0fms",1000*x))
  } else if (x < 60 ){ 
    trimws(sprintf("%3.1fs",x)) 
  } else if (x < 3600){
    m <- x %/% 60
    s <- x - m*60
    trimws(sprintf("%2.0fm %3.1fs", m, s))
  } else {
    # fall-through: hours, minutes, seconds.
    h <- x %/% 3600
    m <- (x - 3600 * h)%/% 60
    s <- x - 3600 * h - 60*m
    sprintf("%dh %dm %3.1fs", h,m,s)
  }
  col <- if (x<0.1) "cyan" else "blue"
  if (color) color_str(str, col) else str
}

color_str <- function(x, color){
  cmap <- c(cyan=36, red=31, green=32, blue = 34)
  sprintf("\033[0;%dm%s\033[0m", cmap[color], x)
}

catf <- function(fmt,...) {cat(sprintf(fmt,...)); flush.console()}


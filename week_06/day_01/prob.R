# Functions taken from the {prob} package.

# Kerns G (2018). _prob: Elementary Probability on Finite Sample Spaces_.
# R package version 1.0-1,
# <https://CRAN.R-project.org/package=prob>.



rolldie <- function(times, nsides = 6) {
  temp = list()
  for (i in 1:times) {
    temp[[i]] <- 1:nsides
  }
  res <- expand.grid(temp, KEEP.OUT.ATTRS = FALSE)
  names(res) <- c(paste(rep("X", times), 1:times, sep = ""))
  return(res)
}

tosscoin <- function (times)
{
  temp <- list()
  for (i in 1:times) {
    temp[[i]] <- c("H", "T")
  }
  res <- expand.grid(temp, KEEP.OUT.ATTRS = FALSE)
  names(res) <- c(paste(rep("toss", times), 1:times, sep = ""))

  return(res)
}

cards <- function (jokers = FALSE)
{
  x <- c(2:10, "J", "Q", "K", "A")
  y <- c("Club", "Diamond", "Heart", "Spade")
  res <- expand.grid(rank = x, suit = y)
  if (jokers) {
    levels(res$rank) <- c(levels(res$rank), "Joker")
    res <- rbind(res, data.frame(rank = c("Joker", "Joker"),
                                 suit = c(NA, NA)))
  }
  return(res)
}


isin <- function (x, y, ordered = FALSE, ...) 
{
  
  apply(x, MARGIN = 1, FUN = \(x) {
    res <- (length(y) <= length(x))
    if (res) {
      temp <- x
      for (i in 1:length(y)) {
        if (is.element(y[i], temp)) {
          if (!ordered) {
            temp <- temp[-which(temp %in% y[i])[1]]
          }
          else {
            temp <- temp[-(1:which(temp %in% y[i])[1])]
          }
        }
        else {
          res <- FALSE
          i <- length(y)
        }
      }
    }
    res
  }, ...)
}
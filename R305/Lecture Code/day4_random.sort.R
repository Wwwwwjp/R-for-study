#' Sort a vector (title at top of "?" help page)
#'
#' Sort a vector into ascending order. ("Description" paragraph)
#' The algorithm used is the worst one I know.
#' @param x    a vector ("Arguments" section)
#' @return     a sorted version of \code{x} ("Value" section)
#' @details    \code{random.sort} randomly permutes ("Details" section)
#'             \code{x} until \code{x} is sorted. It requires
#'             \deqn{(n-1)n!} swaps on average and \deqn{\infty} swaps
#'             in the worst case.
#' @export
#' @examples
#' v = c(4, 2, 1, 3) # ("Examples" section)
#' random.sort(x = v)
random.sort = function(x) {
  while (is.unsorted(x)) {
    x = sample(x)
  }
  return(x)
}

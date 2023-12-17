#' Return the named coefficients
#'
#' Return the named coefficients of a
#' least absolute deviations regression.
#' @param x    a list of class \code{lad} given by \code{lad()}
#' @param ...  further arguments passed to or from other methods
#' @return     the named coefficients vector
#' @details    \code{print.lad} gives the named coefficients vector
#'             from a list of class \code{lad}.
#' @export
print.lad <- function(x, ...) {
  return(x$coefficients)
}
#' Return the coefficients
#'
#' Return a vector of coefficients of a
#' least absolute deviations regression.
#' @param object    a list of class \code{lad} given by \code{lad()}
#' @param ...       further arguments passed to or from other methods
#' @return     a vector of coefficients without names
#' @details    \code{coef.lad} gives a vector of coefficients without names
#'             from a list of class \code{lad}.
#' @export
coef.lad <- function(object, ...) {
  b <- unname(object$coefficients)
  return(c(b[1], b[2]))
}
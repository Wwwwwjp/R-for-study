#' Lad's predictions 
#'
#' Return a vector containing lad's predictions at the \code{x} values in \code{new.x}.
#' least absolute deviations regression.
#' @param object    a list of class \code{lad} given by \code{lad()}
#' @param new.x     a vector of new values for \code{x}
#' @param ...       further arguments passed to or from other methods
#' @return     lad's predictions based on \code{new.x}
#' @details    \code{predict.lad} gives a vector containing lad's predictions
#'             at the \code{x} values in \code{new.x}.
#' @export
predict.lad <- function(object, new.x, ...) {
  b <- unname(object$coefficients)
  return(b[1] + b[2] * new.x)
}
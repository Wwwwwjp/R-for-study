#' Calculate \deqn{n!} (title at top of "?" help page)
#'
#' Calculate \deqn{n!}, "n factorial". ("Description" paragraph)
#' @param n    a nonnegative integer ("Arguments" section)
#' @return     \deqn{n!} ("Value" section)
#' @details    \code{baby.factorial} calculates
#'             \deqn{n(n-1)(n-2)...(3)(2)(1)}. ("Details" section)
#' @export
#' @examples
#' baby.factorial(3) # ("Examples" section)
#' a = 4
#' baby.factorial(n = a)
#'
baby.factorial = function(n) {
  stopifnot(n >= 0)
  
  factors = seq_len(n)
  return(prod(factors))
}

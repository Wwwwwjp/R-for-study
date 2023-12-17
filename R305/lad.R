#' Least absolute deviations regression
#'
#' Do least absolute deviations regression.
#' @param x    a numeric vector
#' @param y    a numeric vector with the same length as \code{x}
#' @return     A list (\code{coefficients}, \code{fitted.values}, \code{residuals})
#'             whose class is "lad".
#' @details    \code{lad} uses \code{optim()} with its (default) Nelder-Mead
#'             algorithm to minimize the sum of absolute deviations (SAD)
#'             Initial values come from \code{lm()}
#' @importFrom stats lm coef optim setNames
#' @export
#' @examples
#' data(area)
#' lad1 = lad(x=area$land, y=area$farm)
#' print(unname(lad1$coefficients))
#' plot(x=area$land, y=area$farm)
#' abline(lm(area$farm ~ area$land))
#' abline(lad1, col = "red")
#' legend(0, 200000, legend = c("lm", "lad"),
#'                   lty = c("solid", "solid"),
#'                   col = c("black", "red"))
#' quantiles <- quantile(area$land, probs = c(0, 0.25, 0.5, 0.75, 1))
#' quantiles <- unname(quantiles)
#' y_hat <- predict(lad1, quantiles)
#' points(quantiles, y_hat, col = "green", pch = 16)

lad = function(x, y){
  sad_function = function(beta) {
    beta0 = beta[1]
    beta1 = beta[2]
    
    y_pred = beta0 + beta1 * x
    sad = sum(abs(y - y_pred))
    return(sad)
  }
  
  lm_model = lm(y ~ x)
  par_values = lm_model$coef
  result = optim(par = par_values, fn = sad_function, method = "Nelder-Mead")
  beta_hat = result$par
  y_hat = beta_hat[1] + beta_hat[2] * x
  res = y - y_hat
  lad_object = list(
    coefficients = setNames(beta_hat, c("(Intercept)", "x")),
    fitted.values = y_hat,
    residuals = res
  )
  class(lad_object) = "lad"
  return(lad_object)
}
area <- read.csv("http://www.stat.wisc.edu/~jgillett/305/1/farmLandArea.csv")
str(area)

k=19000
n = length(area$land)

Tukey <- function(beta) {
  beta0 = beta[1]
  beta1 = beta[2]
  t = area$farm - beta0 - beta1 * area$land
  Tu = 0
  
  for (i in 1:n){
    if(abs(t[i]) > k){
      Tu = Tu + 2 * k * abs(t[i]) - k * k
    }
    else{
      Tu = Tu + t[i] * t[i]
    }
  }
  
  return(Tu / n)
}

gr <- function(beta) {
  beta0 = beta[1]
  beta1 = beta[2]
  t = area$farm - beta0 - beta1 * area$land
  Tu_d0 = 0
  Tu_d1 = 0
  
  for (i in 1:n){
    if(abs(t[i]) > k){
      Tu_d0 = Tu_d0 + 2 * k * sign(t[i])
      Tu_d1 = Tu_d1 + area$land[i] * 2 * k * sign(t[i])
    }
    else{
      Tu_d0 = Tu_d0 + 2 * t[i]
      Tu_d1 = Tu_d1 + area$land[i] * 2 * t[i]
    }
  }
  
  return(c(Tu_d0 * -1 / n, Tu_d1 * -1 / n))
}

optim_nm = optim(par = c(0,0), fn = Tukey, method = "Nelder-Mead")
optim_BFGS = optim(par = c(0,0), fn = Tukey, gr = gr, method = "BFGS")
optim_CG = optim(par = c(0,0), fn = Tukey, gr = gr, method = "CG")

beta_nm = optim_nm$par
beta_BFGS = optim_BFGS$par
beta_CG = optim_CG$par

model = lm(farm ~ land, data = area)

plot(area$land, area$farm, 
     xlab = "land Area", ylab = "farm Area",
     main = "Farm Area vs. Land Area Scatterplot")
abline(model, col = "limegreen") 
abline(a = beta_nm[1], b = beta_nm[2], col = "navy")
abline(a = beta_BFGS[1], b = beta_BFGS[2], col = "black")
abline(a = beta_CG[1], b = beta_CG[2], col = "coral", lty = "dashed")

legend("topleft", legend=c("regression line", "estimated line with Nelder-Mead", 
                           "estimated line with BFGS", "estimated line with CG"), 
       col=c("limegreen", "navy", "black", "coral"), lty=c(1, 1, 1, 2), cex = 0.6)





print(Tukey(beta_nm))
print(Tukey(beta_BFGS))
print(Tukey(beta_CG))
print("When we use BFGS, we get the smallest value")

rou = function(x) {
  y = ifelse(abs(x) > k, 2 * k * abs(x) - k^2, x^2)
  return(y)
}

curve(rou(x), from = -100000, to = 100000)

print("I believe that the rou function grows more slowly 
      when the absolute value of x becomes larger than the square function.
      This means that in this case we take the minimum value and the effect of the 
      large error will not be seen as too serious. So this method is less affected by outliers.")

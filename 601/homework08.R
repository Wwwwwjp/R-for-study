ntreat <- 5; nu1 <- ntreat-1; s2 <- 9; alpha <- 0.05
print("replications power",quote=FALSE)
for(r in 2:20){
  nu2 <- ntreat*r-5
  fcrit <- qf(1-alpha,nu1,nu2)
  ncp <- 10.125*r/s2
  power <- pf(fcrit,nu1,nu2,ncp=ncp,lower.tail=FALSE)
  print(c(r,power),quote=FALSE)
}


time <- c(62,60,63,59, 63,67,71,64,65,66,68,66,71,67,68,68,56,
          62,60,61,63,64,63,59)
poison <- as.factor(rep(1:4,c(4,6,6,8)))

#                                                                                                                                                                                                                                   model <- aov(poison ~ time)
#anova_table <- summary(model)
summary(lm(formula = time ~ poison))
anova(lm(formula = time ~ poison))
print(1 - pf(13.57,3,20))

p = 3.5 * 1e-5
z = qnorm(0.975)
print(p * (1 - p) / (1e-6 / z)^2)

F0 = 13.57
ST0 = 228
R0 = 7

k1 = k2 = k3 = 0
m = 1000000
for (i in 1:m){
  time_ran = sample(time)
  y_dd = mean(time_ran)
  y_1d = mean(time_ran[1:4])
  y_2d = mean(time_ran[5:10])
  y_3d = mean(time_ran[11:16])
  y_4d = mean(time_ran[17:24])
  ST = 4 * (y_1d - y_dd)^2 + 6 * (y_2d - y_dd)^2 + 6 * (y_3d - y_dd)^2 + 8 * (y_4d - y_dd)^2
  SE = sum((time_ran[1:4] - y_1d)^2) + sum((time_ran[5:10] - y_2d)^2) + 
    sum((time_ran[11:16] - y_3d)^2) + sum((time_ran[17:24] - y_4d)^2)
  F_stat = 20 / 3 * ST / SE
  R = max(y_1d, y_2d, y_3d, y_4d) - min(y_1d, y_2d, y_3d, y_4d)
  
  if(F_stat > F0){
    k1 = k1 + 1
  }
  if(ST > ST0){
    k2 = k2 + 1
  }
  if(R > R0){
    k3 = k3 + 1
  }
}

k1/m
k2/m
k3/m

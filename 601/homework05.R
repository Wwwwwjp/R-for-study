library(survival)
library(MASS)
setwd('E:/stat-visp/601')
z <- read.csv("cancerdata.csv")
leg.txt <- c("horTh = no","horTh = yes")
leg.col <- c("blue","red")
leg.lty <- rep(1,2)
y <- z$time
stat <- z$death
treat <- z$horTh
fit.bytreat <- survfit(Surv(y,stat) ~ treat, conf.type="none")
plot(fit.bytreat,conf.int=FALSE,
     col=leg.col,mark.time=FALSE,
     lwd=3,
     main='Kaplan-Meier survival curves')

legend("bottomleft",legend=leg.txt,lty=leg.lty,col=leg.col,lwd=3)
summary(coxph(Surv(time, death)~ . * horTh , data=z))
summary(coxph(Surv(time, death)~ horTh * time , data=z))
summary(coxph(Surv(time, death)~ menostat * horTh, data=z))
head(z)


z <- read.csv("lungcancer.csv")
z$city <- as.factor(z$city); z$age <- as.factor(z$age)
glm(cases/pop ~ city + age, weight=pop, family='binomial', data=z)
mean(z$cases/ z$pop)

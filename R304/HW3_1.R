rm(list = ls()) # initialization

if (!require("XML")) {
  install.packages("XML") # do this once per lifetime
  stopifnot(require("XML")) # do this once per session
}
if (!require("curl")) {
  install.packages("curl") # do this once per lifetime
  stopifnot(require("curl")) # do this once per session
}
table = readHTMLTable(readLines(curl("https://simple.wikipedia.org/wiki/List_of_U.S._states_by_area")),
                      stringsAsFactors = FALSE)

a = table[[1]]
df = a[3:52,][c('V1','V6')]
grep(pattern = "A", x = a)

df$V6 = gsub(pattern = ",", replacement = "", x = df$V6)
names(df) = c("state", "land")
rownames(df) = c(1:50)

setwd('E:/stat-visp/R304')
area = read.csv('farm.csv')

df = df[order(df$state), ]
names(area) = c("state", "farm")
area$land = df$land
area$land = as.numeric(area$land)

if (.Platform$OS.type == "windows") windows() 

plot(area$land, area$farm, 
     xlab = "land Area", ylab = "farm Area",
     main = "Farm Area vs. Land Area Scatterplot")

identify(area$land, area$farm, n = 1, cex = 1, tol = 0.5)

if (.Platform$OS.type == "windows") {
  while (!is.null(dev.list()))  dev.off()
} 
index1 = 43
index2 = 2
model = lm(farm ~ land, data = area)


plot(area$land, area$farm, 
     xlab = "land Area", ylab = "farm Area",
     main = "Farm Area vs. Land Area Scatterplot")
abline(model, col = "blue") 
area_without_alaska = area[-index2, ]  
model_without_alaska = lm(farm ~ land, data = area_without_alaska)


abline(model_without_alaska, col = "red")  

legend("topleft", legend=c("regression line", "regression line with Alaska removed"), 
       col=c("blue", "red"), lwd=2, lty=1, cex = 0.6)


plot(residuals(model), xlab = "State number", ylab = "Residuals", 
     main = "Residual Plot for the original model")

r.jack = numeric(50)
n = 50
for (i in 1:n){
  area_leave_one = area[-i, ]
  model_lm = lm(farm ~ land, data = area_leave_one)
  predicted_dat = predict(model_lm, newdata = area[i, ])
  r.jack[i] = area$farm[i] - predicted_dat 
}
r.jack
plot(r.jack, xlab = "State number", ylab = "Residuals", 
     main = "Residual Plot for the original model")



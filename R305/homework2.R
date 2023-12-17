if (!require("devtools")) {
  install.packages("devtools")
  stopifnot(require("devtools"))
}

# install.packages("roxygen2") to get access to document(), which is also called by check()
if (!require("roxygen2")) {      
  install.packages("roxygen2")   
  stopifnot(require("roxygen2"))
}

setwd("E:/stat-visp/R305")




area = read.csv("http://www.stat.wisc.edu/~jgillett/305/2/farmLandArea.csv")
lad(x=area$land, y=area$farm)


package.name = "robust"
if (dir.exists(package.name)) unlink(package.name, recursive = TRUE)
create(package.name)

new.folder = paste0(package.name, "/R") # function/method source code's destination subfolder

if (length(list.files(new.folder)) > 0) unlink(paste0(new.folder, "/*")) 

file.copy("lad.R", new.folder) 

file.copy("area.R", new.folder)

file.copy("predict.lad.R", new.folder)

file.copy("print.lad.R", new.folder)


file.copy("coef.lad.R", new.folder)


if (!dir.exists(paste0(package.name, "/data"))) dir.create(paste0(package.name, "/data")) 
area = read.csv("http://www.stat.wisc.edu/~jgillett/305/2/farmLandArea.csv")
save(area, file = paste0(package.name, "/data/area.RData"))

document(pkg = package.name)
check(pkg = package.name) 
package.file.name = build(pkg = package.name, )

.rs.restartR()
install.packages(pkgs="robust_0.1.tarr.gz", repos=NULL, type="source")
require("robust")
example(lad)
?lad
?area
?print.lad
?coef.lad
?predict.lad


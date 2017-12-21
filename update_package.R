library(devtools)
library(roxygen2)

setwd("~/ladygolfstats")
document()
setwd("~/")
install("ladygolfstats")

# fix issues with help
.rs.restartR()


N <- c() 
Method <- c() 
for (n in seq(100, 500, by=100)){ 
  N <- append(N, c(n, "")) 
  Method <- append(Method, c("PrimeAvg", "SampAvg")) 
} 
#generate an empty matrix
table <- data.frame(n = N, method = Method, t_1 = NA, t_5 = NA, Gaussian = NA)

#fill in data
distTypes = c("t1", "t5","gaussian") 
nVals = seq(100, 500, by=100) 
i <- 0 
for (n in nVals) { 
  i <- i + 1 
  j <- 0 
  for (dist in distTypes) { 
    j <- j + 1 
    iFile = paste("n", n, sep="", "_", dist, ".txt")
    p <- read.table(iFile) 
    p <- as.data.frame(p) 
    table[2*i-1, j + 2] <- p[1,2] 
    table[2*i, j + 2] <- p[1,3] 
  } 
}
#table 
library(knitr) 
kable(table, "markdown")
## parsing command arguments
for (arg in commandArgs(TRUE)) {
  eval(parse(text=arg))
}

## check if a given integer is prime
isPrime = function(n) {
  if (n <= 3) {
    return (TRUE)
  }
  if (any((n %% 2:floor(sqrt(n))) == 0)) {
    return (FALSE)
  }
  return (TRUE)
}

## estimate mean only using observation with prime indices
estMeanPrimes = function (x) {
  n = length(x)
  ind = sapply(1:n, isPrime)
  return (mean(x[ind]))
}

# simulate data
set.seed(seed)
s1 <- 0
s2 <- 0
# generate data from different dist
for ( i in 1:rep) {
  if (dist == "gaussian"){
    t = rnorm(n,0,1)
  }else if (dist == "t1"){
    t = rt(n, df=1)
  }else if (dist == "t5"){
    t = rt(n, df=5)
  }
  # estimate mean
  m1 <- estMeanPrimes(t)
  m2 <- mean(t)
  s1 <- s1 + (m1-0)^2
  s2 <- s2 + (m2-0)^2
}

outcome <- c(s1/rep, s2/rep)
outcome
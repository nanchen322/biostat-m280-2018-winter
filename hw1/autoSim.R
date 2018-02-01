# autoSim.R
nVals = seq(100, 500, by=100)
distTypes = c('gaussian', 't1', 't5')
rep <- 50
seed <- 280

for (n in nVals) {
  for (dist in distTypes){
    oFile = paste("n", n, sep="", "_", dist, ".txt")
    arg = paste("n=", n, " seed=", seed, "dist=\\\"", dist,"\\\" rep=", rep,sep=" ") 
    sysCall = paste("nohup Rscript runSim.R ", arg, " > ", oFile)
    system(sysCall)
    print(paste("sysCall=", sysCall, sep=""))
  }
}


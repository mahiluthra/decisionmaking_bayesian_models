library(rjags)
library(runjags)
library(parallel)

start_time <- Sys.time()

source("DBDA2E-utilities.R")

dataList = read.csv("data.csv", sep = ",")  # read data file
s = 135   # number of participants
n = 100   # number of trials per participant
dataList = list(x = dataList$x, y = dataList$y, s = s, n = n) # here, x is the outcome variable, and y is the participant's decisions

numSavedSteps=50000  # number of saved steps of the MCMC chain
thinSteps=15    # thinning steps reduces autocrrelation

adaptSteps = 1000  # Number of steps to "tune" the samplers
burnInSteps = 2000

runJagsOut <- run.jags( method="parallel" ,
                        model="SSEVL.txt" , 
                        monitor=c("theta", "alpha", "t", "prob", "omega", "kappa", "m") , 
                        # theta is the exploration parameter, alpha is the recency parameter,
                        # t is the timepoint change parammeter
                        # prob is the probability prameter of the baseline model
                        # omega and kappa are hierchical parameters
                        # m provides model comparison
                        data=dataList ,  
                        #inits=initsList , 
                        n.chains=3 ,
                        adapt=adaptSteps ,
                        burnin=burnInSteps , 
                        sample=ceiling(numSavedSteps/3) ,
                        thin=thinSteps ,
                        summarise=FALSE ,
                        plots=FALSE )

codaSamples = as.mcmc.list( runJagsOut )
save( codaSamples , file=paste("SSEVL_Mcmc.Rdata",sep="") )

end_time <- Sys.time()

print(end_time-start_time)
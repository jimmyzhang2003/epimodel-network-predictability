require(knitr)
require(EpiModel)
opts_chunk$set(comment = NA, message = FALSE, tidy = FALSE)
#initializing network
num.m1 <- 500
num.m2 <- 500
nw <- network.initialize(num.m1 + num.m2, bipartite = num.m1, directed = FALSE)
deg.dist.m1 <- c(0.40, 0.55, 0.04, 0.01)
deg.dist.m2 <- c(0.48, 0.41, 0.08, 0.03)
pois.dists <- c(dpois(0:2, lambda = 0.66), ppois(2, lambda = 0.66, lower = FALSE))
formation <- ~edges + b1degree(0:1) + b2degree(0:1)
target.stats <- c(330, 200, 275, 240, 205)
coef.diss <- dissolution_coefs(dissolution = ~offset(edges), duration = 25, d.rate = 0.005)
est <- netest(nw, formation, target.stats, coef.diss)
dx <- netdx(est, nsims = 3, nsteps = 500)
#parameters
param <- param.net(inf.prob = 0.3, inf.prob.m2 = 0.1, b.rate = 0.005, b.rate.m2 = NA, ds.rate = 0.005, ds.rate.m2 = 0.005, 
 di.rate = 0.005, di.rate.m2 = 0.005)
init <- init.net(i.num = 50, i.num.m2 = 50)
control <- control.net(type = "SI", nsims = 3, nsteps = 500, nwstats.formula = ~edges + meandeg, delete.nodes = TRUE)
#simulations
sim <- netsim(est, param, init, control)
sim
plot(sim, type = "formation", plots.joined = FALSE)
plot(sim, popfrac = FALSE)
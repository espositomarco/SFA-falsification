library(randtoolbox)
source("R/getBounds.R")

gen_input_samples = function(n, d, bounds, sampling="halton", init=TRUE) {
	if (sampling=="halton") return(gen_halton_samples(n, d, init))
	else if (sampling=="uniform") return(gen.random.inputs(n,d))
	else {
		cat("Using random uniform samping.\n")
		return(gen.random.inputs(n,d))
	}
}

# Given the number of observation n, the dimension of each observation d,
# returns a n x d matrix of random uniform input samples, with each parameter
# scaled to its range, according to bounds
gen_rand_input_samples = function(n, d, bounds) {
	sapply(1:d, function(x) runif(n, lwr(bounds, x), upr(bounds, x) ))
}


# Given the number of observation n, the dimension of each observation d,
# returns a n x d matrix of input samples generated through Halton Sequences, 
# with each parameter scaled to its range, according to bounds
gen_halton_samples = function(n, d, init=TRUE) {
	return(halton(n, d, init=init))
}

gen.random.inputs = function(n, d){
	Train.X  = matrix(
		runif(n*d, 0, 1), 
		nrow=n, ncol=d)
	Train.X = as.data.frame(Train.X)
    colnames(Train.X) = sapply((1:d), function(x){paste("X",x, sep="")})

    return(Train.X)

}

library(randtoolbox)
source("R/getBounds.R")

gen_input_samples = function(n, d, bounds, sampling="halton", init=TRUE) {
	if (sampling=="halton") return(gen_halton_samples(n, d, bounds, init))
	else if (sampling=="uniform") return(gen_rand_input_samples(n,d,bounds))
	else {
		print("Using random uniform samping.")
		return(gen_rand_input_samples(n,d,bounds))
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
gen_halton_samples = function(n, d, bounds, init=TRUE) {
	X = halton(n, d, init=init)
	for (i in 1:d) {
		up = upr(bounds, i)
		lo = lwr(bounds, i)
		X[,i] = X[,i] * (up-lo) + lo
	}
	return(X)	
}

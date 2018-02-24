source("R/Model.R")
source("R/sim_utils.R")

# Given an n x d matrix of observations of the input space,
# performs simulations of the model to obtain the n x k matrix of
# the output samples. 
gen_output_samples = function(inputs, k) {
	Y = apply(inputs, 1, function(row) {
		do.call(simulateSamples, list(row))
	}
		)
	if (k > 1) Y = t(Y)
	return(Y)
}

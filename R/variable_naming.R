
# Name the variables
varname = function(x, d, k) {
	if (x<=d) { paste("x", toString(x), sep="")}
	else { paste("y", toString(x-d), sep="")}
}

name_in_out_vars = function(samples, d, k) {
	lapply(1:(d + k), function(x) varname(x,d,k))
}

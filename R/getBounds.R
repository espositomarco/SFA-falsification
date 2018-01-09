
# Read the bounds of the d model parameters. The bounds must be stored
# in a .csv file with d rows and 2 columns, one for the lower bound and
# one for the upper bound.


getBounds = function(bounds_file) { 
	read.csv(bounds_file, header=FALSE, col.names=c("lwr", "upr")) }
	# check that the number of bounds is right

lwr = function(bounds, x) { #check x in bounds
	bounds$lwr[x] 
}

upr = function(bounds,x) { #check x in bounds
	bounds$upr[x] 
}

getLowerBounds = function(bounds, u){
	lower_u = c()
	return(sapply(u,function(x) {lwr(bounds,x)}))
}

getUpperBounds = function(bounds, u){
	upper_u = c()
	return(sapply(u,function(x) {upr(bounds,x)}))
}

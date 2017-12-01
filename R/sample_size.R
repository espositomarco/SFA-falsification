
# This methods compute the minimum sample size with respect to the
# desired accuracy epsilon and confidence delta, according to (Loyola et al., 2016)

# parameter for d <= 9
l = 5
# parameter
min_d = 9

#Computes the Chernoff bound (Loyola et al., 2016) = 1/2e^2 ln(2/d)
get_sPACC = function(epsilon, delta) { 
	1/(2*(epsilon^2))*log(2/delta) 
}

sample_num = function(d, sval) {
	if (d <= min_d) sval^l
	else 10^sval
}

select_min_sval = function(d, epsilon, delta) {
	sPacc = get_sPACC(epsilon, delta)
	sval = 1
	while (sample_num(d, sval) <= sPacc) sval = sval + 1
	return(sval)
}

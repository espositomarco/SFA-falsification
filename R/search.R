# Author: Marco Esposito
source("R/model.R")
source("R/sample_size.R")
source("R/gen_input_samples.R")
source("R/gen_model_samples.R")
source("R/variable_naming.R")
source("R/appr_model.R")
source("R/incr_fun_learning.R")
source("R/getBounds.R")
source("R/model_translation.R")
source("R/sim_utils.R")

random.search = function(solution, max_iter, threshold, step=0.01, maxValue=1, restart=0.02) {
	i = 0
	MAX = 0
	base = init.random.state(solution)
	y_curr = 0
	while(i<=max_iter){
		new = random.neighbor(base,solution,step)
		y = simulateSamples(base)

		if (y > y_curr) {
			y_curr <- y
			base <- new
			print(sprintf("New value: %g",y_curr))
		}

		if(y_curr > MAX) {
			MAX <- y_curr
			print(sprintf("New max: %g",MAX))

		}
		if(y_curr >= threshold || y_curr >= maxValue) break

		if(with.prob(restart)) {
			base = init.random.state(solution)
			cat("Random restart!\n")
		}
		i <- i+1
	}
	return(c(sol=base, y=MAX ))
}

init.random.state = function(solution){
	base = solution
	for (i in (1:length(solution))) {
		if(is.na(solution[i])) base[i] <- runif(1,0.0, 1.0)
	}
	return(base)
}

random.neighbor = function(base, solution, step) {
	v = sample(which(is.na(solution)),1)

	r = runif(1, 0.0, 1.0)
	if(r >= 0.5 || base[v] == 1){ base[v] = base[v] - step }
	else if (r < 0.5 || base[v] == 0) { base[v] = base[v] + step}

	return(base)
}

with.prob = function(p){
	r = runif(1, 0.0, 1.0)
	return(r <= p)
}
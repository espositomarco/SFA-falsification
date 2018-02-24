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

random.search.solution = function(solution, max_iter, threshold, step=0.01, maxValue=1, restart=0.02) {
	i = 0
	MAX = 0
	base = init.random.state(solution)
	y_curr = 0
	while(i<=max_iter){
		new = random.neighbor.solution(base,solution,step)
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

random.neighbor.solution = function(base, solution, step) {
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


random.search = function(initial, max_iter, threshold, step=0.01, maxValue=1, restart=0.05) {
	i = 0
	MAX = 0
	base = initial
	y_curr = simulateSamples(initial)
	sol_x = initial
	plateau_c = 0
	while(i<=max_iter){
		new = random.neighbor(base,step)
		y = simulateSamples(new)
		print(y)

		if (y > y_curr) {
			y_curr <- y
			base <- new
			sol_x <- new
			print(sprintf("New value: %g",y_curr))
			plateau_c <- 0
		} else{
			plateau_c <- plateau_c +1
		}

		if(y_curr > MAX) {
			MAX <- y_curr
			print(sprintf("New max: %g",MAX))

		}
		if(y_curr >= threshold || y_curr >= maxValue) break

		if(plateau_c >= 100 && with.prob(restart)) {
			base = init.random.state(rep(NA,76))
			cat("Random restart!\n")
			plateau_c <- 0
		}
		i <- i+1
	}
	return(c(sol=sol_x, y=MAX ))
}

random.neighbor = function(base, step) {
	v = sample((1:length(base)),1)
	r = runif(1, 0.0, 1.0)
	if(r >= 0.5){ base[v] = max(0,base[v] - step) }
	else if (r < 0.5) { base[v] = min(1,base[v] + step)}
	stopifnot(base[v] >=0)
	return(base)
}


##########################################################

my.random.search = function(appr_model, initial, max_iter, threshold, mstep=0.01, maxValue=24, restart=0.05) {
	#predictors <- get.predictors(appr_model)


	i = 0
	MAX = 0
	base = initial
	y_curr = simulateSamples(initial)
	MAX <- y_curr
	sol_x = initial
	plateau_c = 0
	while(i<=max_iter){
		new_state = my.random.neighbor(base,appr_model,mstep,y_curr)
		#new_state = my.random.neighbor.predict(base,appr_model,mstep,y_curr)
		new = new_state$new
		y_curr = new_state$y
		base <- new
		cat(sprintf("%d: %f\n",i,y_curr))

		if (y_curr > MAX){
			MAX <- y_curr
			sol_x <- base
			plateau_c <- 0
			print(sprintf("New max: %g",MAX))
		} else{
			plateau_c <- plateau_c +1
		}

		
		if(y_curr >= threshold || y_curr >= maxValue ) break
		if(plateau_c >= 10 && with.prob(restart)) {
			base = init.random.state(rep(NA,76))
			cat("Random restart!\n")
			plateau_c <- 0
		}
		i <- i+1
	}
	return(c(sol=sol_x, y=MAX ))
}


my.random.neighbor = function(base, appr_model, mstep, y_curr) {
	predictors = get.predictors(appr_model)
	for (v in predictors){
		v_base = base

		v_base[v] = max(0,base[v] - mstep)		
		y = simulateSamples(v_base)
		if(y>y_curr){
			cat(sprintf("Improved at %d\n",v))
			return(list(new=v_base, y=y))
		}

		v_base[v] = min(1,base[v] + mstep)
		y = simulateSamples(v_base)
		if(y>y_curr){
			cat(sprintf("Improved at %d\n",v))

			return(list(new=v_base, y=y))
		}
	}

	cat("\nMoving to worse solution!\n")

	v = sample((1:length(base)),1)
	r = runif(1, 0.0, 1.0)
	if(with.prob(0.5)){ base[v] = max(0,base[v] - mstep) }
	else { base[v] = min(1,base[v] + mstep)}
	y = simulateSamples(base)
	return(list(new=base, y=y))
}

my.random.neighbor.predict = function(base, appr_model, mstep, y_curr) {
	predictors = get.predictors(appr_model)
	for (v in predictors){
		v_base = base

		v_base[v] = max(0,base[v] - mstep)		
		y = predict(appr_model,v_base)
		if(y>y_curr){
			cat(sprintf("Improved at %d\n",v))
			return(list(new=v_base, y=y))
		}

		v_base[v] = min(1,base[v] + step)
		y = predict(appr_model,v_base)
		if(y>y_curr){
			cat(sprintf("Improved at %d\n",v))

			return(list(new=v_base, y=y))
		}
	}

	cat("Moving to worse solution!\n")

	v = sample((1:length(base)),1)
	r = runif(1, 0.0, 1.0)
	if(with.prob(0.5)){ base[v] = max(0,base[v] - step) }
	else { base[v] = min(1,base[v] + step)}
	y = predict(appr_model,v_base)
	return(list(new=base, y=y))
}
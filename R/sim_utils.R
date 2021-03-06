# Author: Marco Esposito

source("R/getBounds.R")
source("R/Model.R")
source("init_model.R")



get.input.values = function(S, partial=NULL) {
	stopifnot(length(S) == model$d || 
		(!missing(partial) && length(partial)==model$d))

	values = c()
	# for each non-na value in S, convert it and add to values. If NA, add the NA
	for (i in (1:model$d)){
		if (!is.na(S[i])){
			values = c(values, getVarValue(model$bounds,i,S[i]))
		}else{
			values = c(values, NA)
		}
	}

	if (!missing(partial) && !is.null(partial)){
		for(i in (1:model$d)){
			if(!is.na(partial[i])) values[i] = getVarValue(model$bounds,i,partial[i])
		}
	}		
	return(values)
}


# Completes a partial solution with the default input values of the model
merge.solution.default = function(solution){
	return(get.input.values(model$default.samples, partial=solution))
}


# Method that starts a simulation on a given vector of input space samples S, each in [0,1].
# Returns a k-dimensional (row) output vector Y
simulateSamples = function(S=NULL, partial=NULL) {
	if(missing(S) && !missing(partial)) {stop()}
	if(!missing(S)){
		X = get.input.values(S,partial)
		model$write.input.file(X)
	}
	
	
	return(execSimulation())
}

# Method that starts a simulation on a given vector of input space samples S, each in [0,1].
# Returns a k-dimensional (row) output vector Y
simulateInputs = function(inputs) {
	if(missing(inputs)) {stop()}	
	
	model$write.input.file(inputs)
	
	return(execSimulation())
	
}

execSimulation = function() {
	setwd(cmd_path)
	res = system2(sim_command, command_args, stdout=TRUE)
	model$parse.simulation.output(res)
	
}


get.sims.KPIs = function(outputs){
	KPIs = apply(outputs, 1, model$extract.KPIs)
	if(model$k==1) return(KPIs)
	t(KPIs)
}
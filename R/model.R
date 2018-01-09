# This file defines and describes the model to approximate
# There must be declarations for all the model parameters, e.g. the path
# and the command to execute it or the model dimensions d and k.

# The model described in this file is the one in the param_search directory.

source("R/getBounds.R")

path = "/home/marco/Uni/param_search"
cmd_path = "/home/marco/Uni/param_search/tmp"

model_name = "param_search_mdl"

bounds_file = "bounds.csv" # input variables bounds
param_file = "lambda.txt"  # input values file for a simulation
sim_command = "./Test"
command_args = paste0("-overrideFile=", param_file)

# Model Dimensions
d = 76 # inputs

# select output variables to consider:
#  c(1:105) to select all variables
#  c(1,3,78) to select only variables in columns 1,3 and 78

out_vars = c(1:105)
k = length(out_vars)



# Input bounds filename (CSV)
bounds = getBounds(paste(path, bounds_file, sep="/"))


model = list(name=model_name, d=d, k=k, bounds=bounds, out_vars=out_vars)


# Method that starts a simulation on a given input vector X.
# Should return a k-dimensional (row) output vector Y
simulate = function(X) {
	writeParameters(X)
	setwd(cmd_path)
	res = system2(sim_command, command_args, stdout=TRUE)
	parseSimulationResults(res)
}

writeParameters = function(X) {
	fileConn = file(paste(cmd_path, param_file, sep="/"))
	txt = character()
	for (i in 1:d) {
		p = sprintf("lambda[%d]=%f", i, X[i])
		txt = c(txt, p)
		
	}
	writeLines(txt, fileConn)
	close(fileConn)	
}

# Parses the output of a simulation and returns the KPIs values
# in a vector of length k
parseSimulationResults = function(res) {
	R = numeric(0)
	allValues = numeric(0)
	start = length(res)-3
	end = length(res)-1
	#res_as_list = strsplit(res, "\n")[[1]]
	for(i in start:end) {
		values = strsplit(res[i], " = ")[[1]][2]
		values = strsplit(values[[1]], ",")
		for (v in values) allValues = c(allValues, as.double(v))
	}

	for(var in out_vars) {
		R = c(R, as.double(allValues[var]))
	}
	return(R)
}

writeSolutionLambdaHalton = function(X, results,init) {
	lambda = gen_halton_samples(1, d, bounds,init)
	fileConn = file(paste(cmd_path, param_file, sep="/"))
	txt = character()
	for (var in names(results)) {
		lambda[X[var]] = results[[var]]
	}

	for (i in 1:d) {
	p = sprintf("lambda[%d]=%f", i, lambda[i])
	txt = c(txt, p)
		
	}
	writeLines(txt, fileConn)
	close(fileConn)	
	return(txt)
}


simSolution = function() {
	setwd(cmd_path)
	res = system2(sim_command, command_args, stdout=TRUE)
	start = length(res)-3
	end = length(res)-1

	R = numeric(0)
	allValues = numeric(0)

	for(i in start:end) {
		values = strsplit(res[i], " = ")[[1]][2]
		values = strsplit(values[[1]], ",")
		for (v in values) allValues = c(allValues, as.double(v))
	}

	for(var in out_vars) {
		R = c(R, as.double(allValues[var]))
	}
	return(R)
}


writeSolutionLambdaHalton = function(X, results,init) {
	lambda = gen_halton_samples(1, d, bounds,init)
	fileConn = file(paste(cmd_path, param_file, sep="/"))
	txt = character()
	for (var in names(results)) {
		lambda[X[var]] = results[[var]]
	}

	for (i in 1:d) {
	p = sprintf("lambda[%d]=%f", i, lambda[i])
	txt = c(txt, p)
		
	}
	writeLines(txt, fileConn)
	close(fileConn)	
	return(txt)
}


writeLambda = function(sol_X, solution, u){
	fileConn = file(paste(cmd_path, param_file, sep="/"))
	txt = character()
	j = 1
	for(i in (1:d)){
		if(i %in% sol_X){
			x = names(sol_X)[match(i, sol_X)]
			p = sprintf("lambda[%d]=%f", i, solution[x])
			#lambda = c(lambda, solution[x])
		} else{
			p = sprintf("lambda[%d]=%f", i, u[j])
			#lambda = c(lambda,u[j])
			j = j+1
		}
		txt = c(txt,p)
	}
	writeLines(txt, fileConn)
	close(fileConn)	
	return(txt)
}

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
default_param_file = "default_lambda.txt"  # default input values file 
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







# Write input file from inputs X=(x1, ... , xd)
write.input.file = function(X) {
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
	allValues = numeric(0)
	for(i in (1:length(res))){
		line = strsplit(res[i]," = ")[[1]]
		if(line[1] == "CrossCorr"){
			values = line[2]
			values = strsplit(values, ",")[[1]]
			for (v in values) allValues = c(allValues, as.double(v))
			#return(min(allValues))
			#return(length(which(allValues>0.7))/length(allValues))
			#return(length(which(allValues>0.7)))
			return(allValues)
		}
	}




}






readDefaultLambda = function() {
	default_filename = paste(cmd_path, default_param_file, sep="/")
	lambda = readChar(default_filename, file.info(default_filename)$size)
	lambda = strsplit(lambda, "\n")[[1]]
	vals = c()
	for(i in 1:length(lambda)){
		v = as.double(strsplit(lambda[i], "=")[[1]][2])
		vals = c(vals, v)
	}
	return(vals)

}

default = readDefaultLambda()

default.samples = c()
for(i in (1:d)){
	default.samples = c(default.samples, getVarSolution(bounds, i, default[i]))
}

model = list(name=model_name, d=d, k=k, bounds=bounds, out_vars=out_vars, default=default, default.samples=default.samples)
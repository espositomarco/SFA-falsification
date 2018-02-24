# This file defines and describes the model to approximate
# There must be declarations for all the model parameters, e.g. the path
# and the command to execute it or the model dimensions d and k.

# The model described in this file is the one in the param_search directory.
source("R/Model.R")


min.cross.corr = function(outputs){
	return(max(0.001, min(outputs[71:105])))
}

num.over.thresh = function(outputs){
	return(length(which(outputs[71:105]>0.7)))
}

ratio.over.thresh = function(outputs) {
  return(length(which(outputs[71:105]>0.7))/length(outputs[71:105]))
}

#KPI.extractors <- c(num.over.thresh,ratio.over.thresh)
KPI.extractors <- c(ratio.over.thresh)
#KPI.extractors <- NULL

model_name = "GynCycle"

path = "/home/marco/Uni/param_search"
cmd_path = "/home/marco/Uni/param_search/tmp"



bounds_file = "bounds.csv" # input variables bounds
param_file = "lambda.txt"  # input values file for a simulation
default_param_file = "default_lambda.txt"  # default input values file 
sim_command = "./Test"
command_args = paste0("-overrideFile=", param_file)

# Model Dimensions
d = 76 # inputs

n_outputs = 105

k = ifelse(is.null(KPI.extractors),n_outputs,length(KPI.extractors) )

# Parses the output of a simulation and returns the output values
# in a vector of length k
parseSimulationResults = function(res) {
  if(length(res)!=5) return(rep(NA, k))

  outputs = list(SqrNormDiff=c(), AvgDiff=c(),CrossCorr=c())
  
  for(i in (1:length(res))){
    line = strsplit(res[i]," = ")[[1]]
    if(line[1] %in% c("SqrNormDiff","AvgDiff","CrossCorr")) {

      values = strsplit(line[2], ",")[[1]]
      values = sapply(values, as.double)
      if(line[1] == "SqrNormDiff") {outputs$SqrNormDiff <- values}
      if(line[1] == "AvgDiff") {outputs$AvgDiff <- values}
      if(line[1] == "CrossCorr") {outputs$CrossCorr <- values}
      
    }
  }
  
  return(c(outputs$SqrNormDiff, outputs$AvgDiff, outputs$CrossCorr))
}


read.default.inputs = function() {
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


model = Model$new(model_name, path, cmd_path,
	bounds_file,param_file,default_param_file,
	sim_command, command_args,d,k, parse.output=parseSimulationResults,
  read.default=read.default.inputs, write.input=write.input.file,
  KPI.extractors=KPI.extractors)

# This file defines and describes the model to approximate
# There must be declarations for all the model parameters, e.g. the path
# and the command to execute it or the model dimensions d and k.

# The model described in this file is the one in the param_search directory.
library(R6)
source("R/getBounds.R")


Model <- R6Class("Model",
  public = list(
  	name=NULL,
  	path=NULL,
  	cmd_path=NULL,
  	bounds_file=NULL,
  	param_file=NULL,
  	default_param_file=NULL,
  	sim_command=NULL,
  	command_args=NULL,
  	d=NULL,
  	k=NULL,
  	default=NULL,
  	default.samples=NULL,
  	bounds=NULL,  	


    initialize = function(name=stop("No name specified"),path,cmd_path,bounds_file,param_file,
    	default_param_file,sim_command,command_args,d,k,parse.output, read.default,write.input, KPI.extractors=NULL) {
      self$name <- name
  	  self$path <- path
  	  self$cmd_path <- cmd_path
  	  self$bounds_file <- bounds_file
  	  self$param_file <- param_file
  	  self$default_param_file <- default_param_file
  	  self$sim_command <- sim_command
  	  self$command_args <- command_args
  	  self$d <- d
  	  self$k <- k
  	  
  	  self$bounds <- getBounds(paste(self$path, self$bounds_file, sep="/"))
  	  private$KPI.extractors <-KPI.extractors
  	  
  	  private$parse.output <- parse.output
  	  private$read.default <- read.default
  	  private$write.input <- write.input
  	  self$default <- self$read.default.inputs()
  	  self$default.samples <- sapply((1:self$d), function(i) {
				getVarSolution(self$bounds, i, self$default[i])})

    },
    

		extract.KPIs = function(Y){
			if(is.null(private$KPI.extractors)) return(Y)
	    sapply( private$KPI.extractors, function(f) f(Y) )		
		},

		parse.simulation.output = function(res){
			outputs = private$parse.output(res)
			if(is.null(private$KPI.extractors)) return(outputs)

			return(self$extract.KPIs(outputs))
		},

		read.default.inputs =function(){
			private$read.default()
		},

		write.input.file = function(X){
			private$write.input(X)
		}


  ),
  private = list(
    KPI.extractors=NULL,
    parse.output=NULL,
    read.default=NULL,
    write.input=NULL
  )
)

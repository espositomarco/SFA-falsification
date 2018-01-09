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

library(GA)

library(optparse)

option_list = list(
make_option(c("-i", "--maxiter"), type="integer", default="10", 
          help="Max number of iterations of the search algorithm. [default= %default]", 
          metavar="integer"),
make_option(c("-r", "--runs"), type="integer", default="10", 
          help="Max number of runs of the generic algorithm. [default= %default]", 
          metavar="integer"),
make_option(c("-p", "--popsize"), type="integer", default="50", 
          help="Population size for the generic algorithm. [default= %default]", 
          metavar="integer"),
make_option(c("-m", "--method"), type="character", default="random", 
          help="Search method. (genetic, random) [default= %default]", 
          metavar="character"),
make_option(c("-t", "--threshold"), type="numeric", default=0.9, 
              help="Threshold value for the KPIs [default= %default]", metavar="cnumeric"),
make_option(c("-f", "--filename"), type="character", default="opt_res_MAX.txt", 
          help="MILP Solution file name [default= %default]", metavar="character")

)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)


wd = getwd()

res_file_name = opt$filename
threshold = opt$threshold

res = readChar(res_file_name, file.info(res_file_name)$size)

res = strsplit(res, "\n")[[1]]

solution = list()

for(i in (2:(length(res)-1))) {
	r = strsplit(res[i], " ")[[1]]
	r = r[r != ""]
	var = r[1]
	val = as.numeric(r[2])
	solution[[var]] = val

}

sol_X = sapply(names(solution), function(x) {as.numeric(gsub("X","", x))})




writeSolutionLambda = function(lambda) {
	fileConn = file("output/result_params.txt")
	writeLines(lambda, fileConn)
	close(fileConn)	
}

getSolutionRandom = function(maxiter,sol_X, solution,threshold,k){
	sol = c()
	maxKPI = 0.0
	init=TRUE

	for(i in (1:maxiter)){
		lambda = writeSolutionLambdaHalton(sol_X, solution,init)
		init=FALSE
		Y = simSolution()
		n = length(Y[Y>=threshold])
		if (n==k){
			cat(sprintf("\n%f KPIs above the threshold %f\n", n, threshold))
			setwd(wd)
			writeSolutionLambda(lambda)
			break
		} else {
			if(n>maxKPI){
				sol = lambda
				maxKPI = n
			}
		}	
	}
	if(n<k){
		setwd(wd)
		writeSolutionLambda(sol)
		cat(sprintf("\n%f KPIs above the threshold %f\n", maxKPI, threshold))
	}
}

getGlobalMax = function(sol_X, sol, d, bounds, t){
	a = (1:d)
	u_x = a[! a %in% sol_X]
	lower_u = getLowerBounds(bounds, u_x)
	upper_u = getUpperBounds(bounds, u_x)


	GA_sol <- ga(type="real-valued",fitness=utility, 
		min=lower_u, max=upper_u,
		popSize=opt$popsize, maxiter=opt$maxiter, run=opt$runs,
		maxFitness=model$k,monitor=TRUE)

	
	# summary(GA_sol)
	return(GA_sol)
}

utility = function(u){
	writeLambda(sol_X, solution, u)
	Y = simSolution()
	return(length(Y[Y>=threshold]))
}

if(opt$method == "random"){
	cat("\n###########################\nPerforming Random Search...\n")
	getSolutionRandom(opt$maxiter,sol_X,solution,threshold,model$k)

}else if(opt$method =="genetic"){
	cat("\n###########################\nPerforming Search with GA...\n")
	sol <- getGlobalMax(sol_X, solution, model$d, model$bounds,threshold)
	cat("\n###########################\n")
	cat(sprintf("Best solution: \n"))
	print(summary(sol))
}





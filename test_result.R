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
source("R/search.R")

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
make_option(c("-m", "--method"), type="character", default="genetic", 
          help="Search method. (genetic, random) [default= %default]", 
          metavar="character"),
make_option(c("-t", "--threshold"), type="numeric", default=0.7, 
              help="Threshold value for the KPIs [default= %default]", metavar="cnumeric"),
make_option(c("-f", "--filename"), type="character", default="opt_re.txt", 
          help="MILP Solution file name [default= %default]", metavar="character")

)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)


wd = getwd()

res_file_name = opt$filename
threshold = opt$threshold

res = readChar(res_file_name, file.info(res_file_name)$size)

res = strsplit(res, "\n")[[1]]

solution = rep(NA, model$d)

for(i in (2:(length(res)-1))) {
	r = strsplit(res[i], " ")[[1]]
	r = r[r != ""]
	var = as.numeric(gsub("X","", r[1]))
	val = as.numeric(r[2])
	solution[var] = val

}

solution.default = merge.solution.default(solution)





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
		if (Y>=threshold){
			cat(sprintf("\nKPI above the threshold:  %f>=%f\n", Y, threshold))
			setwd(wd)
			writeSolutionLambda(lambda)
			break
		} else {
			if(Y>maxKPI){
				sol = lambda
				maxKPI = Y
			}
		}	
	}
	if(Y<threshold){
		setwd(wd)
		writeSolutionLambda(sol)
		cat(sprintf("\nKPI value: %f < %f\n", maxKPI, threshold))
	}
}

getGlobalMax = function(solution, d, bounds, t){
	lower = rep(0, model$d)
	upper = rep(1, model$d)
	for(i in (1:model$d)){
		if(!is.na(solution[i])){
			lower[i] = solution[i]
			upper[i] = solution[i]
		}
	}


	GA_sol <- ga(type="real-valued",fitness=utility, 
		min=lower, max=upper,
		popSize=opt$popsize, maxiter=opt$maxiter, run=opt$runs,
		maxFitness=1,monitor=TRUE)

	
	# summary(GA_sol)
	return(GA_sol)
}


utility = function(u){
   simulateSamples(u)
}



if(opt$method == "random"){
	cat("\n###########################\nPerforming Random Experiments...\n")
	getSolutionRandom(opt$maxiter,sol_X,solution,threshold,model$k)

}else if(opt$method =="genetic"){
	cat("\n###########################\nPerforming Search with GA...\n")
	sol <- getGlobalMax(solution, model$d, model$bounds,threshold)
	cat("\n###########################\n")
	cat(sprintf("Best solution: \n"))
	print(summary(sol))
}else if(opt$method =="random_search"){
	cat("\n###########################\nPerforming Random Search...\n")
	sol <- random.search(solution, 1000, opt$threshold)
	cat("\n###########################\n")
	cat(sprintf("Best solution: \n"))
	print(summary(sol))
}



# lambda = readDefaultLambda()

# pred_lambda = c()
# for(i in 1:length(lambda)){
# 	pred_lambda = c(pred_lambda,getVarSolution(model$bounds, i, lambda[i]))
# }

# for(var in names(solution)){
# 	sol_n = sol_X[var]
#     # lambda[sol_n] <- getVarValue(model$bounds, sol_n, solution[[var]])
# 	pred_lambda[sol_n] <- solution[[var]]
# }




#############################
# WITH DEFAULT LAMBDA
#############################

# lambda = readDefaultLambda()


# for(var in names(solution)){
#     sol_n = sol_X[var]
#     lambda[sol_n] <- getVarValue(model$bounds, sol_n, solution[[var]])
# }




# writeParameters(lambda)
# Y = simSolution()
# cat(sprintf("\nTHE FINAL KPI VALUE IS: %f\n",Y))
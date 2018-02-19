###################
# Regression Model: "earth" is MARS (Multivariate Adaptive Regression Splines)
###################

#MODEL_FILE = "model.R")
#source(MODEL_FILE)

source("R/model.R")
source("R/sample_size.R")
source("R/gen_input_samples.R")
source("R/gen_model_samples.R")
source("R/variable_naming.R")
source("R/appr_model.R")
source("R/incr_fun_learning.R")
source("R/getBounds.R")
source("R/model_translation.R")
source("R/cl_options.R")

library(earth)

wd = getwd()

opt = CommandLineOptions();
coeff_file_name = sprintf("output/coeff_mars_%dout_%dit_%fthresh_%dpen.csv",model$k, opt$maxiter, opt$threshmars,opt$penalty)

if(!opt$readcoeff || !file.exists(coeff_file_name)){
	##############################
	# Metamodel Building
	##############################
	# learn_res = learn_function(opt$epsilon, opt$delta, 
	# 	opt$sampling, opt$maxiter, opt$readsamples, 
	# 	opt$threshmars,opt$penalty, 
	# 	opt$pmethod, wd)
	# appr_model = learn_res$appr_model
	# errors = learn_res$errors




	n = 3125
    samples = getSamples(n, model, opt$sampling, opt$readsamples,wd)
    # index = seq(1, n, 3)
    # index = (1:10000)
    Train.X = samples$X
    Train.Y = samples$Y
    appr_model = build_earth_appr_model(Train.X, Train.Y,threshmars,penalty,pmethod)

    cat("\nMODEL BUILT\n")
	val_set_filename = "samples/param_search_mdl/243.csv"
	errs = c()

	val_set = read.csv(val_set_filename,header=TRUE)

	mtr = max(Train.Y)
	mte = 0

	for(i in 1:nrow(val_set)){
		X = val_set[i, (1:model$d)]
		y = val_set[i,(model$d+1)]
		y_hat = predict(appr_model, X)
		errs = c(errs, abs(y-(y_hat/1)))

		if (y> mte) mte = y
	}

	acc = length(which(errs<=0.03))/length(errs)

	N_VAL_SAMPLES = 100
	rand.val.data.x  = gen.random.inputs(N_VAL_SAMPLES,model$d)
	rand.val.data.y = gen_output_samples(rand.val.data.x, model$k)

	rand.val.data.y = as.data.frame(rand.val.data.y)
    colnames(rand.val.data.y) = sapply((1:model$k), function(x){paste("Y",x, sep="")})

    r_errs = c()
    rel_errs = c()
    for(i in 1:nrow(rand.val.data.y)){
    	y = rand.val.data.y[i,1]
		y_hat = predict(appr_model, rand.val.data.x[i,])
		r_errs = c(r_errs, abs(y-(y_hat/1)))
		rel_errs = c(rel_errs, 
			100*(abs(y-y_hat)/y))




	}

	r_acc = length(which(r_errs<=0.03))/length(r_errs)
	rel_acc = length(which(abs(rel_errs)<=100))/length(r_errs)








	print(mean(errs))

	print(sprintf("Accuracy reached: %f",acc))

	
	print(sprintf("Max in training: %f",mtr))
	print(sprintf("Max in test: %f",mte))





	setwd(wd)

	coeff_file_name = sprintf("output/coeff_%d.csv",n)
	
	write.csv(appr_model$coefficients, coeff_file_name, quote=FALSE)
}





mdl_plot_file_name = sprintf("plots/m_%do_%dit_%fthresh_%dpen.pdf", model$k, opt$maxiter, opt$threshmars, opt$penalty)
pdf(file=mdl_plot_file_name)
response = 1 # change to plot other responses

plotmo(appr_model, nresponse=response)
# #plot(appr_model, nresponse=response)
dev.off()

# resp_plot_filen_name = sprintf("plots/m_%do_%dit_%fthresh.pdf", model$k, opt$maxiter, opt$threshmars)
# pdf(file=plot_file_name)
# response = 1 # change to plot other responses

# # plotmo(appr_model, nresponse=response)
# plot(appr_model, nresponse=response)
# dev.off()


# model_file_name = sprintf("output/m_%do_%dit.rda", model$k, opt$maxiter)
# save(learn_res, file=model_file_name)


data = MARS_coeff_to_AMPL(coeff_file_name)

data$bounds = model$bounds
data$threshold = opt$threshold;

# data_file_name = sprintf("AMPL/marsmdl_%dout_%dit_%fthresh_%dpen.dat",model$k, opt$maxiter, opt$threshmars,opt$penalty)
# mdl_file_name = sprintf("AMPL/marsmdl_%dout_%dit_%fthresh_%dpen.mod",model$k, opt$maxiter, opt$threshmars,opt$penalty)

data_file_name = sprintf("AMPL/marsmdl_%d.dat",n,model$k, opt$maxiter, opt$threshmars,opt$penalty)
mdl_file_name = sprintf("AMPL/marsmdl_%d.mod",n,model$k, opt$maxiter, opt$threshmars,opt$penalty)

write.AMPL.data(data, data_file_name)

if(opt$problem=="max") {
	#write.MAX.AMPL.model(data, model$k,mdl_file_name)
	write.feasibility.AMPL.model(data, model$k,mdl_file_name)
}else{
	write.MIN.AMPL.model(model$k,mdl_file_name)
}







  

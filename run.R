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
	learn_res = learn_function(opt$epsilon, opt$delta, 
		opt$sampling, opt$maxiter, opt$readsamples, 
		opt$threshmars,opt$penalty, 
		opt$pmethod, wd)
	appr_model = learn_res$appr_model
	errors = learn_res$errors

	setwd(wd)
	
	write.csv(appr_model$coefficients, coeff_file_name, quote=FALSE)
}





# mdl_plot_file_name = sprintf("plots/m_%do_%dit_%fthresh_%dpen.pdf", model$k, opt$maxiter, opt$threshmars, opt$penalty)
# pdf(file=mdl_plot_file_name)
# response = 1 # change to plot other responses

# plotmo(appr_model, nresponse=response)
# #plot(appr_model, nresponse=response)
# dev.off()

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

data_file_name = sprintf("AMPL/marsmdl_%dout_%dit_%fthresh_%dpen.dat",model$k, opt$maxiter, opt$threshmars,opt$penalty)
mdl_file_name = sprintf("AMPL/marsmdl_%dout_%dit_%fthresh_%dpen.mod",model$k, opt$maxiter, opt$threshmars,opt$penalty)

write.AMPL.data(data, data_file_name)

if(opt$problem=="max") {
	write.MAX.AMPL.model(data, model$k,mdl_file_name)
}else{
	write.MIN.AMPL.model(model$k,mdl_file_name)
}

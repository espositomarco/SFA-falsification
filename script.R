###################
# Regression Model: "earth" is MARS (Multivariate Adaptive Regression Splines)
###################

#MODEL_FILE = "model.R")
#source(MODEL_FILE)

source("R/Model.R")
source("init_model.R")
source("R/sample_size.R")
source("R/gen_input_samples.R")
source("R/gen_model_samples.R")
source("R/variable_naming.R")
source("R/appr_model.R")
source("R/incr_fun_learning.R")
source("R/getBounds.R")
source("R/model_translation.R")
source("R/cl_options.R")
source("R/sim_utils.R")

library(earth)

wd = getwd()

opt = CommandLineOptions();



samples = getSamples(100, model, "halton", T,wd,init=T)
cat("\n100 Samples generated.\n")
samples = getSamples(1000, model, "halton", F,wd,init=F)
cat("\n1000 Samples generated.\n")
samples = getSamples(10000, model, "halton", F,wd,init=F)
cat("\n10000 Samples generated.\n")
samples = getSamples(100000, model, "halton", T,wd,init=F)



cat("\nSamples generated.\n")

#appr_model = build_earth_appr_model(samples$X, samples$Y)



#cat("\nMODEL BUILT\n")
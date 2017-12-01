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
library(earth)

wd = getwd()

# Accuracy
epsilon = 0.3

# Confidence param
delta = 0.3

# "HALTON" for Halton Sequence, "UNIFORM" for random uniform
sampling_method = "HALTON"

# Maximum number of iterations for the SSIFL Algorithm

max_iterations = 3

##############################
# Metamodel Building
##############################
res = learn_function(epsilon, delta, sampling_method, max_iterations)
appr_model = res$appr_model
errors = res$errors
summary(appr_model)

setwd(wd)

response = 1 # change to plot other responses

plotmo(appr_model, nresponse=response)

filename = sprintf("output/m_%do_%dit.rda", model$k, max_iterations)
save(res, file=filename)
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

library(earth)

wd = getwd()

# Read existing sample files?
readSamples = TRUE

# Accuracy
epsilon = 0.3

# Confidence param
delta = 0.3

# "HALTON" for Halton Sequence, "UNIFORM" for random uniform
sampling = "HALTON"

# Maximum number of iterations for the SSIFL Algorithm

max_iterations = 3

##############################
# Metamodel Building
##############################
res = learn_function(epsilon, delta, sampling, max_iterations, readSamples,wd)
appr_model = res$appr_model
errors = res$errors
#summary(appr_model)

setwd(wd)
coeff_file_name = sprintf("output/coeff_mars_%dout_%dit.csv",model$k, max_iterations)
write.csv(appr_model$coefficients, coeff_file_name, quote=FALSE)




response = 1 # change to plot other responses

plotmo(appr_model, nresponse=response)

model_file_name = sprintf("output/m_%do_%dit.rda", model$k, max_iterations)
save(res, file=model_file_name)









data = MARS_coeff_to_AMPL(coeff_file_name)

data$bounds = model$bounds

write.AMPL.data(data)
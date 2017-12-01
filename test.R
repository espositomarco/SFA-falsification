# This file is for copy-paste testing with the interactive console. ( > R )

source("model.R")
source("sample_size.R")
source("gen_input_samples.R")
source("gen_model_samples.R")
source("variable_naming.R")
source("appr_model.R")
source("incr_fun_learning.R")
library(earth)

wd = getwd()

epsilon = 0.3
delta = 0.3

iter = 1
max_iter = 3

sampling_method = "HALTON"

max_iterations = 3

sval = select_min_sval(model$d, epsilon, delta)
n = sample_num(model$d, sval)
sprintf("Number of samples: %d", n)
ntest = floor(n/10)
err_momts = list()

Train.X = gen_input_samples(n, model$d, model$bounds, sampling=sampling_method)

Train.Y = gen_output_samples(Train.X, model$k)

appr_model = build_earth_appr_model(Train.X, Train.Y)

Test.X = gen_input_samples(ntest, model$d, model$bounds, sampling=sampling_method)
Test.Y = gen_output_samples(Test.X, model$k)



err_momts[[iter]] = compute_errors(appr_model, Test.X, Test.Y)
check_convergence(err_momts, iter)

(abs(err_momts[[iter]]-err_momts[[iter-1]])/err_momts[[iter-1]])*100 <= deltas

Test.X = Train.X
Test.Y = Train.Y
n = sample_num(model$d, sval+iter)

iter = iter +1

ntest = floor(n/10)

setwd(wd)

summary(metamodel)
plotmo(metamodel, nresponse=89)
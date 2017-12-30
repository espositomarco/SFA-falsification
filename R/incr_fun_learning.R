
# The learn_function function implements Algorithm 1 of "Smart sampling 
# and incremental function learning for very large high dimensional data",
# (Loyola et al., 2016).



source("R/model.R")
source("R/appr_model.R")
source("R/sample_size.R")
source("R/gen_input_samples.R")
source("R/gen_model_samples.R")
library(moments)

Train.X = numeric()
Train.Y = numeric()


# mean_delta = 0.05
# var_delta = 0.05
# skew_delta = 0.05
# kurt_delta = 0.05
mean_delta = 5
var_delta = 5
skew_delta = 5
kurt_delta = 5

deltas = c(mean_delta, var_delta, skew_delta, kurt_delta)

learn_function = function(epsilon, delta, sampling, max_iter,readSamples,wd) {
    sval = select_min_sval(model$d, epsilon, delta)
    n = sample_num(model$d, sval)
    cat(sprintf("Number of samples: %d\n", n))
    cat(sprintf("Building initial approximate model with %d samples...\n", n))
    samples = getSamples(n, model$d, model$bounds, sampling, model$k, model$name, readSamples,wd)

    Train.X = samples$X
    Train.Y = samples$Y
    
    iter = 1
    # mmean = numeric(0)
    # msd = numeric (0)
    # mskew = numeric(0)
    # mkurt = numeric(0)
    err_momts = list()
    while(TRUE) {
        Test.X = Train.X
        Test.Y = Train.Y
        n = sample_num(model$d, sval+iter)
        iter = iter + 1
        cat(sprintf("Started iteration %d with %d samples\n", iter, n))
        cat("Generating the samples...\n")
        samples = getSamples(n, model$d, model$bounds, sampling, model$k, model$name, readSamples,wd)
        Train.X = samples$X
        Train.Y = samples$Y

        # Train.X = gen_input_samples(n, model$d, model$bounds, sampling, init=FALSE)
        # Train.Y = gen_output_samples(Train.X, model$k)
        cat("Building the approximate model...\n")
        appr_model = build_earth_appr_model(Train.X, Train.Y)
        cat(sprintf("Iteration %d completed\n", iter))

        err_momts[[iter]] = compute_errors(appr_model, Test.X, Test.Y)
        if (check_convergence(err_momts, iter, max_iter)) { 
            cat(sprintf("Convergence of errors reached at iteration %d!\n", iter))          
            break
        }        
    }
    return(list(appr_model=appr_model, errors=err_momts))
}



relative_errors = function(actual, predicted) {
    return( abs((actual-predicted)/actual)*100)
}

# MAPE = function(rel_errs) {
#     return (colMeans(rel_errs))
# }

# VAPE = function(rel_errs, mape) {
#     return( colMeans( ( rel_errs - mape )^2 ) )
# }

# SAPE = function(rel_errs, mape) {
#     return( colMeans( ( rel_errs - mape )^3 ) )
# }

# KAPE = function(rel_errs, mape) {
#     return( colMeans( ( rel_errs - mape )^4 ) )
# }

check_convergence = function(errors, iter, max_iter) {
    if (iter == 1) return(FALSE)
    if (iter == max_iter) {
        cat(sprintf("Max number of iterations reached at iteration %d!\n", iter))
        return(TRUE)
    }
    else {
        
        return( iter > 2 && all( (100*(abs(errors[[iter]]-errors[[iter-1]])/errors[[iter-1]])) <= deltas ))
    }
}

compute_errors = function(appr_model, test_samples, actual) {
    predicted = predict(appr_model, newdata=test_samples)

    r_errs = relative_errors(actual, predicted)

    p_errs = list()

    p_errs[[1]] = apply(r_errs, 2, mean)
    p_errs[[2]] = apply(r_errs, 2, sd)
    p_errs[[3]] = apply(r_errs, 2, skewness)
    p_errs[[4]] = apply(r_errs, 2, kurtosis)
    return(matrix(unlist(p_errs), ncol =ncol(r_errs), byrow = TRUE))
}

getSamples = function(n, d, bounds, sampling, k, name, readSamples,wd) {
    filename = sprintf("samples/%s/%d_%d.csv", name, k, n)
    setwd(wd)
    if (!readSamples || !file.exists(filename)){
        Train.X = gen_input_samples(n, d, bounds, sampling)
        Train.Y = gen_output_samples(Train.X, k)
        setwd(wd)
        write.csv(cbind(Train.X, Train.Y), file=filename)
        return(list(X=Train.X, Y=Train.Y))
    } else {
        setwd(wd)
        samples = read.csv(filename,header=TRUE)
        Train.X = samples[,(1:d)]
        Train.Y = samples[,((d+1): (d+k))]
        return(list(X=Train.X, Y=Train.Y))
        
    }
}

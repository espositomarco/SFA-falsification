
# The learn_function function implements Algorithm 1 of "Smart sampling 
# and incremental function learning for very large high dimensional data",
# (Loyola et al., 2016).



source("R/Model.R")
source("R/appr_model.R")
source("R/sample_size.R")
source("R/gen_input_samples.R")
source("R/gen_model_samples.R")
source("R/read_samples.R")
library(moments)


mean_delta = 5
var_delta = 10
skew_delta = 20
kurt_delta = 50

deltas = c(mean_delta, var_delta, skew_delta, kurt_delta)

learn_function_OLD = function(epsilon, delta, sampling, max_iter,
    readSamples,threshmars,penalty, pmethod, wd) {
    sval = select_min_sval(model$d, epsilon, delta)
    n = sample_num(model$d, sval)
    cat(sprintf("Number of samples: %d\n", n))
    cat(sprintf("Generating first %d test samples...\n", n))
    samples = getSamples(n, model, sampling, readSamples,wd)

    Train.X = samples$X
    Train.Y = samples$Y
    
    iter = 1

    err_momts = list()
    while(TRUE) {
        Test.X = Train.X
        Test.Y = Train.Y
        #n = sample_num(model$d, sval+iter)
        n = iter*1000
        iter = iter + 1
        cat(sprintf("Started iteration %d with %d samples\n", iter, n))
        cat("Generating the samples...\n")
        samples = getSamples(n, model, "uniform", readSamples,wd, init=FALSE)
        Train.X = samples$X
        Train.Y = samples$Y

        cat("Building the approximate model...\n")
        appr_model = build_earth_appr_model(Train.X, Train.Y,threshmars,penalty,pmethod)
        cat(sprintf("Iteration %d completed\n", iter))

        err_momts[[iter]] = compute_errors(appr_model, Test.X, Test.Y)
        if (check_convergence(err_momts, iter, max_iter)) { 
            break
        }        
    }
    return(list(appr_model=appr_model, errors=err_momts))
}





learn_function = function(epsilon, delta, sampling, max_iter,
    readSamples,threshmars,penalty, pmethod, wd) {
    sval = select_min_sval(model$d, epsilon, delta)
    n = sample_num(model$d, sval)
    cat(sprintf("Number of samples: %d\n", n))
    cat(sprintf("Generating first %d test samples...\n", n))
    samples = getSamples(n, model, sampling, readSamples,wd)

    Train.X = samples$X
    Train.Y = samples$Y
    cat("Building the approximate model...\n")
    appr_model = build_earth_appr_model(Train.X, Train.Y,threshmars,penalty,pmethod)
    cat(sprintf("Model Rsquared: %f\n", appr_model$rsq))
    cat(sprintf("Model GCV: %f\n", appr_model$gcv))
    iter = 1

    rsq = appr_model$rsq
    gcv = appr_model$gcv

    while(iter <= max_iter) {
        X = Train.X
        Y = Train.Y
        m = iter*1000
        iter = iter + 1

        cat(sprintf("Started iteration %d with %d samples\n", iter, n+m))
        cat("Generating the samples...\n")
        samples = getSamples(m, model, "uniform", readSamples,wd, init=FALSE)
        Train.X = samples$X
        Train.Y = samples$Y
        X = rbind(X, Train.X)
        Y = c(Y, Train.Y)

        cat("Updating the model...\n")

        update(appr_model, x=X, y=Y)        
        
        cat(sprintf("Iteration %d completed\n", iter))
        cat(sprintf("Model Rsquared: %f\n", appr_model$rsq))
        cat(sprintf("Model GCV: %f\n", appr_model$gcv))

        if (appr_model$rsq <= rsq || appr_model$gcv <= gcv) { 
            break
        }
        rsq = appr_model$rsq
        gcv = appr_model$gcv      
    }
    return(appr_model)
}







relative_errors = function(actual, predicted) {
    return( abs((actual-predicted)/actual)*100)
}

absolute_errors = function(actual, predicted) {
    return(abs(actual-predicted))
}

check_convergence = function(errors, iter, max_iter) {
    if (iter == 1) return(FALSE)
    new_errors = (100*(abs(errors[[iter]]-errors[[iter-1]])/errors[[iter-1]]))
        cat("\n############################\nITERATION ERRORS:\n")
        print(new_errors)
        cat("\n############################\n")
    if (iter == max_iter) {
        cat(sprintf("Max number of iterations reached at iteration %d\n", iter))
        return(TRUE)
    }
    else {
        
        return( iter > 2 && all( new_errors <= deltas ))
    }
}

compute_errors = function(appr_model, test_samples, actual) {
    predicted = predict(appr_model, newdata=test_samples)

    #a_errs = relative_errors(actual, predicted)
    a_errs = absolute_errors(actual,predicted)

    p_errs = list()

    p_errs[[1]] = apply(a_errs, 2, mean)
    p_errs[[2]] = apply(a_errs, 2, sd)
    p_errs[[3]] = apply(a_errs, 2, skewness)
    p_errs[[4]] = apply(a_errs, 2, kurtosis)

    m = matrix(unlist(p_errs), ncol =ncol(a_errs), byrow = TRUE)
    print(p_errs[[1]])

    return(m)
}



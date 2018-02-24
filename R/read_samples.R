# Author: Marco Esposito

source("R/gen_input_samples.R")
source("R/gen_model_samples.R")

getSamples = function(n, model, sampling, readSamples,wd, filename=NULL, init=TRUE) {
    if(missing(filename)){
        if(sampling=="halton"){
            filename = sprintf("samples/%s/all_%d.csv", model$name, n)
        }else{
            filename = sprintf("samples/%s/%d_105.csv", model$name, n)
        }
    }

    print(filename)
    
    setwd(wd)
    if (!readSamples || !file.exists(filename)){
        X = gen_input_samples(n, model$d, sampling,init)
        
        Y = gen_output_samples(X, model$k)

        X = as.data.frame(X)
        colnames(X) = sapply((1:model$d), function(x){paste("X",x, sep="")})

        Y = as.data.frame(Y)
        colnames(Y) = sapply((1:model$k), function(x){paste("Y",x, sep="")})
        setwd(wd)
        
        write.csv(cbind(X, Y), 
            file=filename,row.names=FALSE,quote=FALSE)
        return(list(X=X, Y=Y))
    } else {
        cat("Reading samples from file.\n")
        nobug = halton(n, model$d, init=init)
        setwd(wd)
        samples = read.csv(filename,header=TRUE)
        X = samples[,(1:model$d)]
        #X = as.data.frame(X)
        colnames(X) = sapply((1:model$d), function(x){paste("X",x, sep="")})

        outputs = samples[,(model$d+1):(ncol(samples))]
        Y = get.sims.KPIs(outputs)
        if(model$k>1){
            colnames(Y) = sapply((1:model$k), function(x){paste("Y",x, sep="")})
        }
        return(list(X=X, Y=Y))
        
    }
}


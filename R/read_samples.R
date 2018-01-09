# Author: Marco Esposito

getSamples = function(n, model, sampling, readSamples,wd, init=TRUE) {
    filename = sprintf("samples/%s/%d.csv", model$name, n)
    setwd(wd)
    if (!readSamples || !file.exists(filename)){
        Train.X = gen_input_samples(n, model$d, model$bounds, sampling,init)
        Train.X = as.data.frame(Train.X)
        colnames(Train.X) = sapply((1:model$d), function(x){paste("X",x, sep="")})

        Train.Y = gen_output_samples(Train.X, model$k)
        Train.Y = as.data.frame(Train.Y)
        colnames(Train.Y) = sapply((1:model$k), function(x){paste("Y",x, sep="")})
        setwd(wd)
        
        write.csv(cbind(Train.X, Train.Y), 
            file=filename,row.names=FALSE,quote=FALSE)
        return(list(X=Train.X, Y=Train.Y))
    } else {
        nobug = halton(n, model$d, init=init)
        setwd(wd)
        samples = read.csv(filename,header=TRUE)
        Train.X = samples[,(1:model$d)]
        Train.X = as.data.frame(Train.X)
        colnames(Train.X) = sapply((1:model$d), function(x){paste("X",x, sep="")})
        Train.Y = samples[,((model$d+1): ncol(samples))]
        Train.Y = as.data.frame(Train.Y)
        Train.Y = Train.Y[,model$out_vars]
        if(model$k>1){
            colnames(Train.Y) = sapply((1:model$k), function(x){paste("Y",x, sep="")})
        }
        return(list(X=Train.X, Y=Train.Y))
        
    }
}
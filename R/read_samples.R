# Author: Marco Esposito

getSamples = function(n, d, bounds, sampling, k, name, readSamples,wd) {
    filename = sprintf("samples/%s/%d_%d.csv", name, k, n)
    setwd(wd)
    if (!readSamples || !file.exists(filename)){
        Train.X = gen_input_samples(n, d, bounds, sampling)
        Train.X = as.data.frame(Train.X)
        colnames(Train.X) = sapply((1:d), function(x){paste("X",x, sep="")})

        Train.Y = gen_output_samples(Train.X, k)
        Train.Y = as.data.frame(Train.Y)
        colnames(Train.Y) = sapply((1:k), function(x){paste("Y",x, sep="")})
        setwd(wd)
        
        write.csv(cbind(Train.X, Train.Y), 
            file=filename,row.names=FALSE,quote=FALSE)
        return(list(X=Train.X, Y=Train.Y))
    } else {
        setwd(wd)
        samples = read.csv(filename,header=TRUE)
        Train.X = samples[,(1:d)]
        Train.X = as.data.frame(Train.X)
        colnames(Train.X) = sapply((1:d), function(x){paste("X",x, sep="")})
        Train.Y = samples[,((d+1): (d+k))]
        Train.Y = as.data.frame(Train.Y)
        colnames(Train.Y) = sapply((1:k), function(x){paste("Y",x, sep="")})
        return(list(X=Train.X, Y=Train.Y))
        
    }
}
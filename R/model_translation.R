# Author: Marco Esposito

source("R/getBounds.R")

library(gtools)

MARS_coeff_to_AMPL = function(coeff_file_name) {
	coeff = read.csv(coeff_file_name, header=TRUE,
		stringsAsFactors=FALSE)

	intercepts = as.data.frame(coeff[1,(2:ncol(coeff))])

	coeff = coeff[-1,]
	df = as.data.frame(
		matrix(
			rep(0,nrow(coeff)*2),
			nrow=nrow(coeff), ncol=2))

	colnames(df) = c("variable", "knot")

	coeff = cbind(coeff, df)   

	for (i in 1:nrow(coeff)) {
		row = coeff[i,]
		varKnot = getVarAndKnot(row$X)
		var = varKnot$var
		knot = varKnot$knot
		row$variable = var
		row$knot = knot
		coeff[i,] = row
	}

	coeff = coeff[order(coeff$knot),]

	inputs = mixedsort(unique(coeff$var))
	d = length(inputs)
	k = ncol(coeff) - 3

	weights = matrix(rep(list(),d*k ), nrow=d, ncol=k)

	rownames(weights) = inputs
	colnames(weights) = colnames(coeff)[2:(k+1)]

	knots = list()
	for(v in inputs){
		knots[[v]] = list()
	}

    X_has_init_piece = c()

	for(i in (1:nrow(coeff))){
        knot = coeff[i,]$knot		
		var = coeff[i,]$var

        if(knot<0) {
            X_has_init_piece = c(X_has_init_piece, var)
        }
        knot = abs(coeff[i,]$knot)
		if (!(knot %in% knots[[var]])) {
			knots = addKnot(knots, var, knot)
		}

		for(target in colnames(weights)){
			weights = addCoeff(weights, var, target, coeff[i,target]) 
		}
	}

    X_has_init_only = c()
    X_has_init = c()
    for(v in X_has_init_piece){
        if(length(knots[[v]]) > 1){
            X_has_init = c(X_has_init, v)
        } else{
            X_has_init_only = c(X_has_init_only, v)
        }
    }

    for(v in rownames(weights)){
        for(t in colnames(weights)){
            if(v %in% X_has_init_only){
                weights[v,t][[1]] = c(weights[v,t][[1]], 0)
            } else if(!(v %in% X_has_init)){
                weights[v,t][[1]] = c(0,weights[v,t][[1]])
            }
        }
    }

	return(list(knots=knots, intercepts=intercepts,
		weights=weights))
}


write.AMPL.data = function(data) {
	fileConn<-file("AMPL/marsmodel.dat")
	text = c("data;\n","set INPUTS := ")
	inputs = paste(names(data$knots), collapse=" ")
	text = c(text,inputs, ";\n")
	outputs = paste(names(data$intercepts), collapse=" ")
	text = c(text, "\nset OUTPUTS := ",outputs, ";\n")

	npiece = c()
	for (v in names(data$knots)){
        npiece=c(npiece,paste(v, length(data$knots[[v]])+1 ))		
	}

	text = c(text, "\n\nparam npiece := ", paste(npiece,collapse="\n"), ";\n")

	knots = c()


	for(v in names(data$knots)){
		for(i in 1:(length(data$knots[[v]])))
			knots = c(knots, 
				paste(v, 
					paste(i,data$knots[[v]][[i]])
			))
	}

	text = c(text, "\nparam knot := ", paste(knots, collapse="\n"), ";\n")

	intercepts = c()
	for (obj in names(data$intercepts)){
		intercepts = c(intercepts, 
			paste(paste(obj, data$intercepts[,obj])))
	}
	text = c(text, "\nparam intercept := ", intercepts, ";\n")


	# tss = c()
 #    for (obj in colnames(data$intercepts)){
 #        tss = c(tss, 
 #            paste(obj, "0.9"))
 #    }
 #    text = c(text, "\nparam threshold := ", tss, ";")

    text = c(text, "\nparam threshold := ", data$threshold, " ;")




	x_nums = as.integer(sapply(names(data$knots), function(x) {gsub("X","",x)}))

	lb = c()
	ub = c()

	for (i in x_nums){
		lb = c(lb, paste(paste("X",i,sep=""),lwr(data$bounds, i)))
		ub = c(ub, paste(paste("X",i,sep=""),upr(data$bounds, i)))
	}

	text = c(text, "\nparam lb :=", lb, ";")
	text = c(text, "\nparam ub :=", ub, ";")


    weights = c()
    for (v in rownames(data$weights)){
        for( t in colnames(data$weights)){
            wvt = data$weights[v,t][[1]]
            for (i in (1:length(wvt))){
                weights = c(weights,
                        paste(v,
                            paste(t, 
                                paste(i, wvt[i])
                    )))
            }
        }
    }

    text = c(text, "\nparam weight := ", paste(weights,collapse="\n"), ";")

	writeLines(text, fileConn)
	return(close(fileConn))
}


addKnot = function(knots, i, value) {
	knots[[i]]= c(knots[[i]],value)
	return(knots)
}

addCoeff = function(weights, i, j, v) {
	weights[i,j][[1]] = c(weights[i,j][[1]], v)
	return(weights)
}

getVarAndKnot = function(term) {
	term = gsub("h\\(|\\)","",term)
	tl = strsplit(term, "-")[[1]]
	if (substring(tl[1], 1, 1)!="X") {
		w_type = 1
		var = tl[2]
		knot = -as.numeric(tl[1])
	} else {
		w_type = 2
		var = tl[1]
		knot = as.numeric(tl[2])
	}
	return(list(var=var, knot=knot))

}



write.AMPL.model = function(k){
fileConn<-file("AMPL/marsmodel.mod")
	text = c("set INPUTS;","
set OUTPUTS;","
param npiece {INPUTS} integer >= 1;","
param knot {i in INPUTS, p in 1..npiece[i]-1};","
param weight {i in INPUTS, o in OUTPUTS, p in 1..npiece[i]};","
#param threshold {OUTPUTS};","
param threshold;","
param lb {i in INPUTS};","
param ub {i in INPUTS} > lb[i];","
param intercept {OUTPUTS};","
var X {i in INPUTS} >= lb[i], <= ub[i];")

	objective = "maximize MyObjective%d:\n 
		intercept[\"Y%d\"] +\n
		sum {i in INPUTS} \n
			<< {p in 1..npiece[i]-1} knot[i,p];\n
			   {p in 1..npiece[i]} weight[i,\"Y%d\",p] >>\n
				(X[i],knot[i,1]);\n"

	objectives = c()
	for(j in 1:k){
		objectives = c(objectives, sprintf(objective,j,j,j))
	}
    text = c(text, objectives)

	writeLines(text, fileConn)
	return(close(fileConn))
}
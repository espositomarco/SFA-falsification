# Author: Marco Esposito

source("R/getBounds.R")

library(gtools)

MARS_coeff_to_AMPL = function(coeff_file_name) {
	coeff = read.csv(coeff_file_name, header=TRUE,
		stringsAsFactors=FALSE)
	icpts_cols = 2:ncol(coeff)

	intercepts = as.data.frame(coeff[1,icpts_cols])
	if(ncol(intercepts)==1) {colnames(intercepts) = c("Y1")}

	coeff = coeff[-1,]
	df = as.data.frame(
		matrix(
			rep(0,nrow(coeff)*3),
			nrow=nrow(coeff), ncol=3))

	colnames(df) = c("variable", "knot", "type")

	coeff = cbind(coeff, df)
	

	for (i in 1:nrow(coeff)) {
		row = coeff[i,]
		termInfo = getVarAndKnot(row$X)
		row$variable = termInfo$var
		row$knot = termInfo$knot
		row$type = termInfo$type
		coeff[i,] = row
	}
	coeff = coeff[,-1]

	# coeff = coeff[order(coeff$knot),]

	# inputs = mixedsort(unique(coeff$var))
	# d = length(inputs)
	# k = ncol(coeff) - 3

	# weights = matrix(rep(list(),d*k ), nrow=d, ncol=k)

	# rownames(weights) = inputs
	# colnames(weights) = colnames(coeff)[2:(k+1)]

	# knots = list()
	# for(v in inputs){
	# 	knots[[v]] = list()
	# }

 #    X_has_init = c()

	# for(i in (1:nrow(coeff))){
 #        knot = coeff[i,]$knot		
	# 	var = coeff[i,]$var

 #        if(knot<0) {
 #            X_has_init = c(X_has_init, var)
 #        }
 #        knot = abs(knot)
	# 	if (!(knot %in% knots[[var]])) {
	# 		knots = addKnot(knots, var, knot)
	# 	}

	# 	for(target in colnames(weights)){
	# 		weights = addCoeff(weights, var, target, coeff[i,target]) 
	# 	}
	# }
	# X_has_init = mixedsort(X_has_init)
	# X_not_init = inputs[! inputs %in% X_has_init]

	# X_has_init_only = X_has_init[
	# 	sapply(X_has_init,
	# 		function(x) length(weights[x,1][[1]])==1)]

 #    for(v in rownames(weights)){
 #        for(t in colnames(weights)){
 #            if(v %in% X_has_init_only){
 #                weights[v,t][[1]] = c(weights[v,t][[1]], 0)
 #            } else if(v %in% X_not_init){
 #                weights[v,t][[1]] = c(0,weights[v,t][[1]])
 #            }
 #        }
 #    }

 #    if(ncol(weights)==1) colnames(weights) <- c("Y1")

	# return(list(knots=knots, intercepts=intercepts,
	# 	weights=weights))

	return(list(intercepts=intercepts,
		coeff=coeff))
}


write.AMPL.data = function(data,filename) {
	fileConn<-file(filename)
	text = c("data;\n","set INPUTS := ")
	inputs = mixedsort(unique(data$coeff$variable))

	inputs_str = paste(inputs, collapse=" ")
	text = c(text,inputs_str, ";\n")
	outputs = paste(names(data$intercepts), collapse=" ")
	text = c(text, "\nset OUTPUTS := ",outputs, ";\n")

	# npiece = c()
	# for (v in names(data$knots)){
 #        npiece=c(npiece,paste(v, length(data$knots[[v]])+1 ))		
	# }

	# text = c(text, "\n\nparam npiece := ", paste(npiece,collapse="\n"), ";\n")

	# knots = c()


	# for(v in names(data$knots)){
	# 	for(i in 1:(length(data$knots[[v]])))
	# 		knots = c(knots, 
	# 			paste(v, 
	# 				paste(i,data$knots[[v]][[i]])
	# 		))
	# }

	# text = c(text, "\nparam knot := ", paste(knots, collapse="\n"), ";\n")

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




	x_nums = as.integer(sapply(inputs, function(x) {gsub("X","",x)}))

	lb = c()
	ub = c()

	for (i in x_nums){
		lb = c(lb, paste(paste("X",i,sep=""),lwr(data$bounds, i)))
		ub = c(ub, paste(paste("X",i,sep=""),upr(data$bounds, i)))
	}

	text = c(text, "\nparam lb :=", lb, ";")
	text = c(text, "\nparam ub :=", ub, ";")


    # weights = c()
    # for (v in rownames(data$weights)){
    #     for( t in colnames(data$weights)){
    #         wvt = data$weights[v,t][[1]]
    #         for (i in (1:length(wvt))){
    #             weights = c(weights,
    #                     paste(v,
    #                         paste(t, 
    #                             paste(i, wvt[i])
    #                 )))
    #         }
    #     }
    # }

    # text = c(text, "\nparam weight := ", paste(weights,collapse="\n"), ";")

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
		var = tl[2]
		knot = as.numeric(tl[1])
		type=2
	} else {
		var = tl[1]
		knot = as.numeric(tl[2])
		type=1
	}
	return(list(var=var, knot=knot,type=type))

}


write.MAX.AMPL.model = function(data,k,filename){
fileConn<-file(filename)
	text = c("set INPUTS;","
set OUTPUTS;","
#param threshold {OUTPUTS};","
param threshold;","
param lb {i in INPUTS};","
param ub {i in INPUTS} > lb[i];","
param intercept {OUTPUTS};","
var X {i in INPUTS} >= lb[i], <= ub[i];\n\n")

	


	for(j in 1:k){
		objective = sprintf("maximize MyObjective%d:\n 
		intercept[\"Y%d\"]",j,j)

		for(i in 1:nrow(data$coeff)){
			row = data$coeff[i,]
			if (row$type==1){
				term = sprintf("\n+ <<%f; 0,%f>> X[\"%s\"]",
					row$knot, row[[j]], row$variable)
			} else{ #type == 2
				term = sprintf("\n+ <<%f; %f,0>> (X[\"%s\"],%f)",
					row$knot, row[[j]], row$variable, row$knot)
			}

			objective = paste(objective,term)
		}
		objective = c(objective,";\n\n")
		text = c(text,objective)
	}

	writeLines(text, fileConn)
	return(close(fileConn))
}



write.MAX.AMPL.model.OLD = function(k,filename){
fileConn<-file(filename)
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

write.MIN.AMPL.model = function(k){
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

	objective = "minimize MyObjective%d:\n 
		(intercept[\"Y%d\"] +\n
		sum {i in INPUTS} \n
			<< {p in 1..npiece[i]-1} knot[i,p];\n
			   {p in 1..npiece[i]} weight[i,\"Y%d\",p] >>\n
				(X[i],knot[i,1])) - threshold;\n

		subject to Thresh%d:\n
			(intercept[\"Y%d\"] +\n
				sum {i in INPUTS} \n
				<< {p in 1..npiece[i]-1} knot[i,p];\n
				   {p in 1..npiece[i]} weight[i,\"Y%d\",p] >>\n
					(X[i],knot[i,1])) >= threshold"

	objectives = c()
	for(j in 1:k){
		objectives = c(objectives, sprintf(objective,j,j,j, j, j, j))
	}
    text = c(text, objectives)
    
	writeLines(text, fileConn)
	return(close(fileConn))
}
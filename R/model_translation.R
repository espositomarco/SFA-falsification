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

 #    text = c(text, "\nparam threshold := ", data$threshold, " ;")




	# x_nums = as.integer(sapply(inputs, function(x) {gsub("X","",x)}))

	# lb = c()
	# ub = c()

	# for (i in x_nums){
	# 	lb = c(lb, paste(paste("X",i,sep=""),lwr(data$bounds, i)))
	# 	ub = c(ub, paste(paste("X",i,sep=""),upr(data$bounds, i)))
	# }

	# text = c(text, "\nparam lb :=", lb, ";")
	# text = c(text, "\nparam ub :=", ub, ";")



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
				term = sprintf("\n+ <<%.20f; 0,%.20f>> X[\"%s\"]",
					row$knot, row[[j]], row$variable)
			} else{ #type == 2
				term = sprintf("\n+ <<%.20f; %.20f,0>> (X[\"%s\"],%.20f)",
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

write.feasibility.AMPL.model = function(data,k,filename){
fileConn<-file(filename)
	text = c("set INPUTS;","
set OUTPUTS;","
#param threshold {OUTPUTS};","
param threshold;","
param lb {i in INPUTS};","
param ub {i in INPUTS} > 0;","
param intercept {OUTPUTS};","
var X {i in INPUTS} >= 0, <= 1;\n\n")

	


	for(j in 1:k){
		objective = sprintf("subject to Threshold%d:\n 
		(intercept[\"Y%d\"]",j,j)

		for(i in 1:nrow(data$coeff)){
			row = data$coeff[i,]
			if (row$type==1){
				term = sprintf("\n+ <<%.20f; 0,%.20f>> X[\"%s\"]",
					row$knot, row[[j]], row$variable)
			} else{ #type == 2
				term = sprintf("\n+ <<%.20f; %.20f,0>> (X[\"%s\"],%.20f)",
					row$knot, row[[j]], row$variable, row$knot)
			}

			objective = paste(objective,term)
		}
		objective = c(objective,") >= 0.7;\n\n")
		text = c(text,objective)
	}

	writeLines(text, fileConn)
	return(close(fileConn))
}
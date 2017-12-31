# Author: Marco Esposito

source("R/getBounds.R")

MARS_coeff_to_AMPL = function(coeff_file_name) {
	coeff = read.csv(coeff_file_name, header=TRUE,
		stringsAsFactors=FALSE)

	emptyrow <- data.frame(matrix(0, ncol = ncol(coeff)-1, nrow = 1),
		stringsAsFactors=FALSE)

	intercepts = as.data.frame(coeff[1,(2:ncol(coeff))])
	colnames(intercepts) = sapply(
		(1:model$k), 
		function(x) {paste("Y",x,sep="")})


	knots <- data.frame(
                 knot=character(),
                 stringsAsFactors=FALSE)

	weight1 <- emptyrow
	colnames(weight1) = (1:ncol(weight1))
	weight2 <- emptyrow
	colnames(weight2) = (1:ncol(weight2))
	

	for(i in (2:nrow(coeff))){
		row = coeff[i,]
		term = gsub("h\\(|\\)","",row$X)
		tl = strsplit(term, "-")[[1]]
		if (substring(tl[1], 1, 1)!="X") {
			w_type = 1
			var = tl[2]
			knot = tl[1]
		} else {
			w_type = 2
			var = tl[1]
			knot = tl[2]
		}

		if (!(var %in% row.names(knots))) {
			nr<-data.frame(knot=knot)
			rownames(nr) = c(var)
			knots = rbind(knots,nr)
		}


		if (w_type == 1){
			if (!(var %in% row.names(weight1))) {
				nw1 = data.frame(coeff[i,(2:ncol(coeff))])
				colnames(nw1) = colnames(weight1)
				rownames(nw1) = c(var)
				weight1 = rbind(weight1,nw1)
			} else {
				weight1[var,] = coeff[i,(2:ncol(coeff))]
			}

			if (!(var %in% row.names(weight2))) {
				nw2 = emptyrow
				colnames(nw2) = colnames(weight2)
				rownames(nw2) = c(var)
				weight2 = rbind(weight2,nw2)
			}
		} else {
			if (!(var %in% row.names(weight2))) {
				nw2 = data.frame(coeff[i,(2:ncol(coeff))])
				colnames(nw2) = colnames(weight2)
				rownames(nw2) = c(var)
				weight2 = rbind(weight2,nw2)
			} else {
				weight2[var,] = coeff[i,(2:ncol(coeff))]
			}

			if (!(var %in% row.names(weight1))) {
				nw1 = emptyrow
				colnames(nw1) = colnames(weight1)
				rownames(nw1) = c(var)
				weight1 = rbind(weight1,nw1)
			}
		}


	}

	w1 = data.frame(weight1[-1,])
	colnames(w1) = colnames(weight1)
	rownames(w1) = rownames(weight1)[-1]

	w2 = data.frame(weight2[-1,])
	colnames(w2) = colnames(weight2)
	rownames(w2) = rownames(weight2)[-1]

	return(list(knots=knots, intercepts=intercepts,
		weight1=w1, weight2=w2))
}


write.AMPL.data = function(data) {
	fileConn<-file("AMPL/marsmodel.dat")
	text = c("data;","set INPUTS := ")
	inputs = sprintf("%s",rownames(data$knots))
	text = c(text,inputs, ";")
	outputs = sprintf("%s",colnames(data$intercepts))
	text = c(text, "set OUTPUTS := ",outputs, ";")
	
	knots = c()
	for (knot in rownames(data$knots)){
		knots = c(knots, paste(knot, data$knots[knot,]))
	}
	text = c(text, "param knot := ", knots, ";")

	intercepts = c()
	for (obj in colnames(data$intercepts)){
		intercepts = c(intercepts, 
			paste(obj, data$intercepts[,obj]))
	}
	text = c(text, "param intercept := ", intercepts, ";")

	weights1 = c()
	for(i in rownames(data$weight1)){
		for (j in colnames(data$weight1)){
			weights1 = c(weights1,
				paste(paste(i,paste("Y",j,sep="")),data$weight1[i,j]))
		}
	}

	text = c(text, "param weight1 := ",weights1, ";")

	weights2 = c()
	for(i in rownames(data$weight2)){
		for (j in colnames(data$weight2)){
			weights2 = c(weights2,
				paste(paste(i,paste("Y",j,sep="")),data$weight2[i,j]))
		}
	}

	text = c(text, "param weight2 := ",weights2, ";")


	tss = c()
	for (obj in colnames(data$intercepts)){
		tss = c(tss, 
			paste(obj, "0.9"))
	}
	text = c(text, "param threshold := ", tss, ";")




	x_nums = as.integer(sapply(rownames(data$knots), function(x) {gsub("X","",x)}))

	lb = c()
	ub = c()

	for (i in x_nums){
		lb = c(lb, paste(paste("X",i,sep=""),lwr(data$bounds, i)))
		ub = c(ub, paste(paste("X",i,sep=""),upr(data$bounds, i)))
	}

	text = c(text, "param lb :=", lb, ";")
	text = c(text, "param ub :=", ub, ";")





	writeLines(text, fileConn)
	return(close(fileConn))
}

# Author: Marco Esposito

MARS_coeff_to_AMPL = function(coeff_file) {
	coeff = read.csv(coeff_file, header=TRUE,
		stringsAsFactors=FALSE)

	emptyrow <- data.frame(matrix(0, ncol = ncol(coeff)-1, nrow = 1),
		stringsAsFactors=FALSE)

	intercepts = coeff[1,(2:ncol(coeff))]

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
}

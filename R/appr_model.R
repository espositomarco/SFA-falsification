# Author: Marco Esposito

# This file contains all the functions to build a (regression) metamodel
# starting from the n x d matrix of input space samples X and the
# n x k matrix of output space samples Y.

library(earth)

# nfold value for cross validation
CVnFold = 0

# Minimum number of samples for which Y scaling is performed (for small values, it fails)
MIN_SCALE = 10

# Builds an additive MARS model with scaling of Y (if more than 10 samples)
build_earth_appr_model = function(X, Y, thresh, penalty,pmethod) {
	#earth(x=X, y=Y, degree=degree, nfold = CVnFold, Scale.y=(nrow(Y)> MIN_SCALE), keepxy=TRUE)
	#earth(x=X, y=Y, degree=degree, nfold = CVnFold,pmethod="none")#, keepxy=TRUE) #, nk=5)
	earth(x=X, y=Y, #penalty=penalty, thresh=thresh, 
	Scale.y=TRUE, keepxy=TRUE,trace=1)#,
	#nfold=CVnFold, pmethod=pmethod )
}


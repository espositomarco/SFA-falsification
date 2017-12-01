# This file defines and describes the model to approximate
source("getBounds.R")
####
# Model Name
####
model_name = "TestModel"

####
# Model Dimensions
####
d = 5 # inputs
k = 5 # outputs

####
# Input bounds filename (CSV)
####

bounds_file = "testBounds.csv"

bounds = getBounds(bounds_file)


model = list(name=model_name, d=d, k=k, bounds=bounds)



f_1 = function(X) { 3*sinpi(5*X[2] )} # f(x) = 3sin(5x)
f_2 = function(X) { X[1] / 2 + 1/3 * X[2] + X[1]*X[2] }
f_3 = function(X) { -3*X[1] + 2*X[2]^2 }

f_4 =  function(X) { X[5]^2  + 4  }
f_5 =  function(X) { X[2]    + 5  }
f_6 =  function(X) { X[4]^2  + 6  }
f_7 =  function(X) { X[7]^5  + 7  }
f_8 =  function(X) { X[8]^5  + 8  }
f_9 =  function(X) { X[9]^5  + 9  }
f_10 = function(X) { X[10]^5 + 10 }
f_11 = function(X) { X[11]^5 + 11 }
f_12 = function(X) { X[12]^5 + 12 }
f_13 = function(X) { X[13]^5 + 13 }
f_14 = function(X) { X[14]^5 + 14 }
f_15 = function(X) { X[15]^5 + 15 }
f_16 = function(X) { X[16]^5 + 16 }
f_17 = function(X) { X[17]^5 + 17 }
f_18 = function(X) { X[18]^5 + 18 }
f_19 = function(X) { X[19]^5 + 19 }
f_20 = function(X) { X[20]^5 + 20 }
f_21 = function(X) { X[21]^5 + 21 }
f_22 = function(X) { X[22]^5 + 22 }
f_23 = function(X) { X[23]^5 + 23 }
f_24 = function(X) { X[24]^5 + 24 }
f_25 = function(X) { X[25]^5 + 25 }
f_26 = function(X) { X[26]^5 + 26 }
f_27 = function(X) { X[27]^5 + 27 }
f_28 = function(X) { X[28]^5 + 28 }
f_29 = function(X) { X[29]^5 + 29 }
f_30 = function(X) { X[30]^5 + 30 }

#funcs = list(f_1, f_2, f_3, f_4, f_5, f_6, f_7, f_8, f_9, f_10, f_11, f_12, f_13, f_14, f_15, f_16, f_17, f_18, f_19, f_20, f_21, f_22, f_23, f_24, f_25, f_26, f_27, f_28, f_29, f_30)
funcs = list(f_2, f_3, f_4, f_5, f_6)
#funcs = list(f_6)


# Method that starts a simulation on a given input vector X.
# Should return a k-dimensional output vector Y
simulate = function(X) {
	sapply(1:k, function(i) funcs[[i]](X))
}

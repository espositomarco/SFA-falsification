set INPUTS;
set OUTPUTS;

param knot {INPUTS};
param weight1 {INPUTS,OUTPUTS};
param weight2 {INPUTS,OUTPUTS};
# param threshold {OUTPUTS};
param lb {i in INPUTS};
param ub {i in INPUTS} > lb[i];
param intercept {OUTPUTS};

var X {i in INPUTS} >= lb[i], <= ub[i];

maximize MyObjective: 
	sum {j in OUTPUTS}
		(intercept[j] +
		sum {i in INPUTS} 
			<< knot[i]; weight1[i,j], weight2[i,j] >>
				(X[i],knot[i]));

# subject to Thresh {j in OUTPUTS}:
# 	intercept[j] + 
# 	sum {i in INPUTS} 
# 			<< knot[i]; weight1[i,j], weight2[i,j] >>
# 				(X[i],knot[i]) >= threshold[j];
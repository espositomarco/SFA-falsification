set INPUTS;
set OUTPUTS;

param npiece {INPUTS} integer >= 1;

param knot {i in INPUTS, p in 1..npiece[i]-1};
param weight {i in INPUTS, o in OUTPUTS, p in 1..npiece[i]};
#param threshold {OUTPUTS};
param threshold;
param lb {i in INPUTS};
param ub {i in INPUTS} > lb[i];
param intercept {OUTPUTS};

var X {i in INPUTS} >= lb[i], <= ub[i];

maximize MyObjective: 
	sum {j in OUTPUTS}
		(intercept[j] +
		sum {i in INPUTS} 
			<< {p in 1..npiece[i]-1} knot[i,p];
			   {p in 1..npiece[i]} weight[i,j,p] >>
				(X[i],knot[i,1]));

subject to Thresh {j in OUTPUTS}:
	intercept[j] +
		sum {i in INPUTS} 
			<< {p in 1..npiece[i]-1} knot[i,p];
			   {p in 1..npiece[i]} weight[i,j,p] >>
				(X[i],knot[i,1]) >= 
				#threshold[j];
				threshold;
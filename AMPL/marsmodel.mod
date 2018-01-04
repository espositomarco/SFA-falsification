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
maximize MyObjective1:
 
		intercept["Y1"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y1",p] >>

				(X[i],knot[i,1]);

maximize MyObjective2:
 
		intercept["Y2"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y2",p] >>

				(X[i],knot[i,1]);

maximize MyObjective3:
 
		intercept["Y3"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y3",p] >>

				(X[i],knot[i,1]);

maximize MyObjective4:
 
		intercept["Y4"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y4",p] >>

				(X[i],knot[i,1]);

maximize MyObjective5:
 
		intercept["Y5"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y5",p] >>

				(X[i],knot[i,1]);

maximize MyObjective6:
 
		intercept["Y6"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y6",p] >>

				(X[i],knot[i,1]);

maximize MyObjective7:
 
		intercept["Y7"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y7",p] >>

				(X[i],knot[i,1]);

maximize MyObjective8:
 
		intercept["Y8"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y8",p] >>

				(X[i],knot[i,1]);

maximize MyObjective9:
 
		intercept["Y9"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y9",p] >>

				(X[i],knot[i,1]);

maximize MyObjective10:
 
		intercept["Y10"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y10",p] >>

				(X[i],knot[i,1]);

maximize MyObjective11:
 
		intercept["Y11"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y11",p] >>

				(X[i],knot[i,1]);

maximize MyObjective12:
 
		intercept["Y12"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y12",p] >>

				(X[i],knot[i,1]);

maximize MyObjective13:
 
		intercept["Y13"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y13",p] >>

				(X[i],knot[i,1]);

maximize MyObjective14:
 
		intercept["Y14"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y14",p] >>

				(X[i],knot[i,1]);

maximize MyObjective15:
 
		intercept["Y15"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y15",p] >>

				(X[i],knot[i,1]);

maximize MyObjective16:
 
		intercept["Y16"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y16",p] >>

				(X[i],knot[i,1]);

maximize MyObjective17:
 
		intercept["Y17"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y17",p] >>

				(X[i],knot[i,1]);

maximize MyObjective18:
 
		intercept["Y18"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y18",p] >>

				(X[i],knot[i,1]);

maximize MyObjective19:
 
		intercept["Y19"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y19",p] >>

				(X[i],knot[i,1]);

maximize MyObjective20:
 
		intercept["Y20"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y20",p] >>

				(X[i],knot[i,1]);

maximize MyObjective21:
 
		intercept["Y21"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y21",p] >>

				(X[i],knot[i,1]);

maximize MyObjective22:
 
		intercept["Y22"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y22",p] >>

				(X[i],knot[i,1]);

maximize MyObjective23:
 
		intercept["Y23"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y23",p] >>

				(X[i],knot[i,1]);

maximize MyObjective24:
 
		intercept["Y24"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y24",p] >>

				(X[i],knot[i,1]);

maximize MyObjective25:
 
		intercept["Y25"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y25",p] >>

				(X[i],knot[i,1]);

maximize MyObjective26:
 
		intercept["Y26"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y26",p] >>

				(X[i],knot[i,1]);

maximize MyObjective27:
 
		intercept["Y27"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y27",p] >>

				(X[i],knot[i,1]);

maximize MyObjective28:
 
		intercept["Y28"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y28",p] >>

				(X[i],knot[i,1]);

maximize MyObjective29:
 
		intercept["Y29"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y29",p] >>

				(X[i],knot[i,1]);

maximize MyObjective30:
 
		intercept["Y30"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y30",p] >>

				(X[i],knot[i,1]);

maximize MyObjective31:
 
		intercept["Y31"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y31",p] >>

				(X[i],knot[i,1]);

maximize MyObjective32:
 
		intercept["Y32"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y32",p] >>

				(X[i],knot[i,1]);

maximize MyObjective33:
 
		intercept["Y33"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y33",p] >>

				(X[i],knot[i,1]);

maximize MyObjective34:
 
		intercept["Y34"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y34",p] >>

				(X[i],knot[i,1]);

maximize MyObjective35:
 
		intercept["Y35"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y35",p] >>

				(X[i],knot[i,1]);

maximize MyObjective36:
 
		intercept["Y36"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y36",p] >>

				(X[i],knot[i,1]);

maximize MyObjective37:
 
		intercept["Y37"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y37",p] >>

				(X[i],knot[i,1]);

maximize MyObjective38:
 
		intercept["Y38"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y38",p] >>

				(X[i],knot[i,1]);

maximize MyObjective39:
 
		intercept["Y39"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y39",p] >>

				(X[i],knot[i,1]);

maximize MyObjective40:
 
		intercept["Y40"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y40",p] >>

				(X[i],knot[i,1]);

maximize MyObjective41:
 
		intercept["Y41"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y41",p] >>

				(X[i],knot[i,1]);

maximize MyObjective42:
 
		intercept["Y42"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y42",p] >>

				(X[i],knot[i,1]);

maximize MyObjective43:
 
		intercept["Y43"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y43",p] >>

				(X[i],knot[i,1]);

maximize MyObjective44:
 
		intercept["Y44"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y44",p] >>

				(X[i],knot[i,1]);

maximize MyObjective45:
 
		intercept["Y45"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y45",p] >>

				(X[i],knot[i,1]);

maximize MyObjective46:
 
		intercept["Y46"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y46",p] >>

				(X[i],knot[i,1]);

maximize MyObjective47:
 
		intercept["Y47"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y47",p] >>

				(X[i],knot[i,1]);

maximize MyObjective48:
 
		intercept["Y48"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y48",p] >>

				(X[i],knot[i,1]);

maximize MyObjective49:
 
		intercept["Y49"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y49",p] >>

				(X[i],knot[i,1]);

maximize MyObjective50:
 
		intercept["Y50"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y50",p] >>

				(X[i],knot[i,1]);

maximize MyObjective51:
 
		intercept["Y51"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y51",p] >>

				(X[i],knot[i,1]);

maximize MyObjective52:
 
		intercept["Y52"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y52",p] >>

				(X[i],knot[i,1]);

maximize MyObjective53:
 
		intercept["Y53"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y53",p] >>

				(X[i],knot[i,1]);

maximize MyObjective54:
 
		intercept["Y54"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y54",p] >>

				(X[i],knot[i,1]);

maximize MyObjective55:
 
		intercept["Y55"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y55",p] >>

				(X[i],knot[i,1]);

maximize MyObjective56:
 
		intercept["Y56"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y56",p] >>

				(X[i],knot[i,1]);

maximize MyObjective57:
 
		intercept["Y57"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y57",p] >>

				(X[i],knot[i,1]);

maximize MyObjective58:
 
		intercept["Y58"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y58",p] >>

				(X[i],knot[i,1]);

maximize MyObjective59:
 
		intercept["Y59"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y59",p] >>

				(X[i],knot[i,1]);

maximize MyObjective60:
 
		intercept["Y60"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y60",p] >>

				(X[i],knot[i,1]);

maximize MyObjective61:
 
		intercept["Y61"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y61",p] >>

				(X[i],knot[i,1]);

maximize MyObjective62:
 
		intercept["Y62"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y62",p] >>

				(X[i],knot[i,1]);

maximize MyObjective63:
 
		intercept["Y63"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y63",p] >>

				(X[i],knot[i,1]);

maximize MyObjective64:
 
		intercept["Y64"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y64",p] >>

				(X[i],knot[i,1]);

maximize MyObjective65:
 
		intercept["Y65"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y65",p] >>

				(X[i],knot[i,1]);

maximize MyObjective66:
 
		intercept["Y66"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y66",p] >>

				(X[i],knot[i,1]);

maximize MyObjective67:
 
		intercept["Y67"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y67",p] >>

				(X[i],knot[i,1]);

maximize MyObjective68:
 
		intercept["Y68"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y68",p] >>

				(X[i],knot[i,1]);

maximize MyObjective69:
 
		intercept["Y69"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y69",p] >>

				(X[i],knot[i,1]);

maximize MyObjective70:
 
		intercept["Y70"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y70",p] >>

				(X[i],knot[i,1]);

maximize MyObjective71:
 
		intercept["Y71"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y71",p] >>

				(X[i],knot[i,1]);

maximize MyObjective72:
 
		intercept["Y72"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y72",p] >>

				(X[i],knot[i,1]);

maximize MyObjective73:
 
		intercept["Y73"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y73",p] >>

				(X[i],knot[i,1]);

maximize MyObjective74:
 
		intercept["Y74"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y74",p] >>

				(X[i],knot[i,1]);

maximize MyObjective75:
 
		intercept["Y75"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y75",p] >>

				(X[i],knot[i,1]);

maximize MyObjective76:
 
		intercept["Y76"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y76",p] >>

				(X[i],knot[i,1]);

maximize MyObjective77:
 
		intercept["Y77"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y77",p] >>

				(X[i],knot[i,1]);

maximize MyObjective78:
 
		intercept["Y78"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y78",p] >>

				(X[i],knot[i,1]);

maximize MyObjective79:
 
		intercept["Y79"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y79",p] >>

				(X[i],knot[i,1]);

maximize MyObjective80:
 
		intercept["Y80"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y80",p] >>

				(X[i],knot[i,1]);

maximize MyObjective81:
 
		intercept["Y81"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y81",p] >>

				(X[i],knot[i,1]);

maximize MyObjective82:
 
		intercept["Y82"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y82",p] >>

				(X[i],knot[i,1]);

maximize MyObjective83:
 
		intercept["Y83"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y83",p] >>

				(X[i],knot[i,1]);

maximize MyObjective84:
 
		intercept["Y84"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y84",p] >>

				(X[i],knot[i,1]);

maximize MyObjective85:
 
		intercept["Y85"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y85",p] >>

				(X[i],knot[i,1]);

maximize MyObjective86:
 
		intercept["Y86"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y86",p] >>

				(X[i],knot[i,1]);

maximize MyObjective87:
 
		intercept["Y87"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y87",p] >>

				(X[i],knot[i,1]);

maximize MyObjective88:
 
		intercept["Y88"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y88",p] >>

				(X[i],knot[i,1]);

maximize MyObjective89:
 
		intercept["Y89"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y89",p] >>

				(X[i],knot[i,1]);

maximize MyObjective90:
 
		intercept["Y90"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y90",p] >>

				(X[i],knot[i,1]);

maximize MyObjective91:
 
		intercept["Y91"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y91",p] >>

				(X[i],knot[i,1]);

maximize MyObjective92:
 
		intercept["Y92"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y92",p] >>

				(X[i],knot[i,1]);

maximize MyObjective93:
 
		intercept["Y93"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y93",p] >>

				(X[i],knot[i,1]);

maximize MyObjective94:
 
		intercept["Y94"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y94",p] >>

				(X[i],knot[i,1]);

maximize MyObjective95:
 
		intercept["Y95"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y95",p] >>

				(X[i],knot[i,1]);

maximize MyObjective96:
 
		intercept["Y96"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y96",p] >>

				(X[i],knot[i,1]);

maximize MyObjective97:
 
		intercept["Y97"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y97",p] >>

				(X[i],knot[i,1]);

maximize MyObjective98:
 
		intercept["Y98"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y98",p] >>

				(X[i],knot[i,1]);

maximize MyObjective99:
 
		intercept["Y99"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y99",p] >>

				(X[i],knot[i,1]);

maximize MyObjective100:
 
		intercept["Y100"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y100",p] >>

				(X[i],knot[i,1]);

maximize MyObjective101:
 
		intercept["Y101"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y101",p] >>

				(X[i],knot[i,1]);

maximize MyObjective102:
 
		intercept["Y102"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y102",p] >>

				(X[i],knot[i,1]);

maximize MyObjective103:
 
		intercept["Y103"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y103",p] >>

				(X[i],knot[i,1]);

maximize MyObjective104:
 
		intercept["Y104"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y104",p] >>

				(X[i],knot[i,1]);

maximize MyObjective105:
 
		intercept["Y105"] +

		sum {i in INPUTS} 

			<< {p in 1..npiece[i]-1} knot[i,p];

			   {p in 1..npiece[i]} weight[i,"Y105",p] >>

				(X[i],knot[i,1]);


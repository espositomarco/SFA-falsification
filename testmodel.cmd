option gurobi_options 'predual -1';
solve;
expand MyObjective;
display X;
include "globals.mzn";

% PARAMETERS
int: n = 8;
set of int: NOTE = 1..n;
set of int: ORDER = 1..n;
set of int: NOTE1 = 1..n-1;
set of int: ORDER1 = 1..n-1;

% DECISIONS
array[ORDER] of var NOTE: order;
array[ORDER1] of var NOTE1: difference;

% DECISION BIJECTIONS
array[NOTE] of var ORDER: posn;
array[NOTE1] of var ORDER1: dposn;

constraint inverse(order, posn);
constraint inverse(difference, dposn);

constraint abs(posn[1] - posn[n]) = 1;
constraint dposn[n - 1] = min(posn[1], posn[n]);

constraint forall(i in 1..n-1)
  (abs(order[i] - order[i+1]) = difference[i]);

% OBJECTIVE
solve satisfy;

output ["order = " ++ show(order) ++ ";\n"] ++
       ["diffs = " ++ show(difference) ++ ";\n"] ++
       ["posn  = " ++ show(posn) ++ ";\n"] ++
       ["dposn = " ++ show(dposn) ++ ";\n"];

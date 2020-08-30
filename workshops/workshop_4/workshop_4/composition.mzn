include "globals.mzn";

% PARAMETERS
int: n = 20;

% DECISIONS
array[1..n] of var 1..n: order;
array[1..n-1] of var 1..n-1: difference;

constraint alldifferent(order);
constraint alldifferent(difference);

constraint forall(i in 1..n-1)
  (abs(order[i] - order[i+1]) = difference[i]);

% OBJECTIVE
solve satisfy;

output fix([if difference[i] < 10 then "\(order[i]) " else "\(order[i])  " endif | i in 1..n-1]) ++ ["\(order[n])"] ++
       ["\n"] ++
       fix([if order[i] < 10 then " \(difference[i])" else "  \(difference[i])" endif | i in 1..n-1]);

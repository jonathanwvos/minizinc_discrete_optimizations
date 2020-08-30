enum Actions = { Heat, Strongly_Heat, Cool, Strongly_Cool, Do_Nothing };

array[int] of int: readings;
int: start;
int: n = length(readings);
set of int: TINDEX = 0..n;
set of int: RINDEX = 1..n;
array[TINDEX] of var 25..30: temp;

array[Actions] of int: adjust = [1, 4, -2, -5, 0];
array[Actions] of int: consumption = [1, 5, 3, 9, 0];
array[RINDEX] of var Actions: choice;

constraint forall(i in RINDEX)
  (temp[i] = (readings[i] + temp[i-1]) div 2 + adjust[choice[i]]);

var int: cost = sum(i in RINDEX)(consumption[choice[i]]);

solve satisfy;

output ["Temp = \(temp)\nChoice = \(choice)\nCost = \(cost)"];

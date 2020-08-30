enum MOVES = {ManyStabber, CrossSlash, BouncyCutter, SwingCutter, OneStabber};
int: timeBound = 9;
array[MOVES] of int: power = [6, 8, 5, 3, 4];
array[MOVES] of int: duration = [4, 5, 3, 2, 3];

var set of MOVES: occur;
% array[MOVES] of var bool: occur;

% constraint forall(i in MOVES)(occur[i] >= 0);
% constraint forall(i in MOVES)(occur[i] <= 1);

constraint (sum(i in occur)(duration[i])) <= timeBound;

solve maximize sum(i in occur)(power[i]);

output [show(occur)];

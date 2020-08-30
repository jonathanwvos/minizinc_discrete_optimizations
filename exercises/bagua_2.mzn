% DATA
int: nSpots = 10;
set of int: SPOT = 1..nSpots;
int: size = 2;
array[SPOT] of int: damage = [10, 8, 4, 2, 6, 9, 5, 3, 8, 10];
enum SYMB = {ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT};
array[SYMB] of set of SPOT: group = [{1,4,6}, {1,2,6,7}, {1,3,6,8}, {1,2,3}, {2,9,10}, {5,6,8,10}, {7,8,10}, {1,4,5}];


% DECISIONS
array[1..size] of var SPOT: attacks;

% CONSTRAINTS
constraint forall(i in 1..size-1)(attacks[i] < attacks[i+1]);
constraint forall(s in SYMB)(sum(i in 1..size)
  (attacks[i] in group[s]) <= 1);

var int: totalDamage = sum(i in attacks)(damage[i]);

solve maximize totalDamage;

output ["Attacks = \(attacks) & Damage = \(totalDamage)"];

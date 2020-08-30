% assignment 2
% select a set of raiding warrior
enum WARRIOR;
WARRIOR: dummy;
enum CLAN; % the clan they belong too

int: l; % minimum raid party size
int: u; % maximum raid party size
int: m; % limit of hatreds

array[WARRIOR] of int: strength;
array[WARRIOR] of CLAN: clan;

array[CLAN,CLAN] of 0..1: hates;

% DECISIONS
array[1..u] of var WARRIOR: raid;
var int: obj;

% CONSTRAINTS
constraint forall(i in 1..u-1)
  (raid[i] >= (raid[i] != dummy) + raid[i+1]);
constraint forall(i in 1..l)
  (raid[i] != dummy);
constraint sum(i,j in 1..u where i < j)
  (hates[clan[raid[i]], clan[raid[j]]]) <= m;
constraint sum(w in 1..u where raid[w] != dummy)
  (strength[raid[w]]) = obj;

solve maximize obj;

% RESULTS
set of WARRIOR: raid_set :: output_only = { fix(w) | w in raid } diff { dummy };

output ["raid = \(raid_set);\nobj = \(obj);"];

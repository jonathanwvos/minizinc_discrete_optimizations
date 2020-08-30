% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy;

% PARAMETERS
int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

% DECISIONS
array[1..u] of var NEGOTIATOR: party;
var int: obj;

% CONSTRAINTS
constraint length([n | n in party where n != dummy]) >= l; % LOWER BOUND
constraint forall(i in 1..u-1)
  (party[i] >= (party[i] != dummy) + party[i+1]);          % ORDERING
constraint sum(i,j in 1..u where i < j)(joint[party[i], party[j]]) >= m;
constraint obj = min([honor[party[n]] | n in 1..u where party[n] != dummy]);

% RESULT
solve maximize obj;

set of NEGOTIATOR: party_set :: output_only = { fix(n) | n in party} diff { dummy };

output ["party = \(party_set)\nobj = \(obj)"];

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
var set of NEGOTIATOR: party;
var int: obj;

% CONSTRAINTS
constraint l <= card(party) /\ card(party) <= u;
constraint sum(n1,n2 in party where n1 < n2)(joint[n1, n2]) >= m;
constraint obj = min([honor[n] | n in party]);

solve maximize obj;

output ["party = \(party);\nobj = \(obj)"];

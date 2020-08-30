include "globals.mzn";

int: n; % number of court members
set of int: COURT = 1..n;
int: emperor = 1;
array[COURT] of int: rank;
array[COURT] of int: ability;

int: m; % number of horses
set of int: HORSE = 1..m;
array[HORSE] of int: beauty;
array[HORSE] of int: speed;

array[COURT,HORSE] of int: enjoy;

% INTERMEDIATES
int: upper_bound = max(n,m);
set of int: COURT1 = 1..upper_bound;
set of int: HORSE1 = 1..upper_bound;

array[COURT1] of int: rank1 = array1d(COURT1, rank ++ [0 | c in n+1..upper_bound]);
array[COURT1] of int: ability1 = array1d(COURT1, ability ++ [0 | c in n+1..upper_bound]);
array[HORSE1] of int: beauty1 = array1d(HORSE1, beauty ++ [0 | h in m+1..upper_bound]);
array[HORSE1] of int: speed1 = array1d(HORSE1, speed ++ [0 | h in m+1..upper_bound]);
array[COURT1, HORSE1] of int: enjoy1 = array2d(COURT1, HORSE1, [ if c <= n /\ h <= m then enjoy[c,h] else 0 endif | c in COURT1, h in HORSE1 ]);

% DECISIONS
array[HORSE1] of var COURT1: riders;
array[COURT1] of var HORSE1: mounts;
array[COURT1] of var int: enjoyment;

constraint inverse(riders, mounts);

constraint forall(h1, h2 in HORSE1 where h1 != h2)(
    rank1[riders[h1]] > rank1[riders[h2]] -> (
      (beauty1[h1] >= beauty1[h2]) \/
      (m > n -> not(h2 in HORSE)) \/
      (m > n + 1 -> not(h1 in HORSE) /\ not(h2 in HORSE))
    )
);

constraint forall(c1, c2 in COURT1 where c1 != c2)(
    speed1[mounts[c1]] > speed1[mounts[c2]] -> (
      (ability1[c1] >= ability1[c2]) \/
      (n > m -> not(c1 in COURT)) \/
      (n > m + 1 -> not(c1 in COURT) /\ not(c2 in COURT))
    )
);

% MORE COURT MEMBERS THAN HORSES -> ALL HORSES ARE USED
constraint n > m -> (
  sum(c in COURT1)(mounts[c] in HORSE) = m
);

% MORE HORSES THAN COURT MEMBERS -> ALL COURT MEMBERS ARE USED
constraint m > n -> (
  sum(h in HORSE1)(riders[h] in COURT) = n
);

% OBJECTIVE
constraint forall(c in COURT1)(
    enjoyment[c] = enjoy1[c, mounts[c]] /\
    enjoyment[c] != -1
);

constraint forall(c in COURT1 where emperor < c)(
  enjoyment[emperor] > enjoyment[c]
);

var int: obj = sum(enjoyment);

solve maximize obj;

array[COURT] of var HORSE union {0}: horses;

constraint forall(c in COURT)(
  horses[c] = if mounts[c] in HORSE then mounts[c] else 0 endif
);

output ["horse = "] ++ [show(horses)] ++ [";\n"] ++ ["obj = \(obj);"];

% Beauty Trap
% Perform the most seductive dance
include "globals.mzn";

enum LEGS = {spin, leap, waltz, curtsey, prep, stand};
enum ARMS = {beckon, out, up, wrapped, neutral};
enum FACE = {smile, wink, batt, think, glow, blank};

int: maxlen;
set of int: STEP = 1..maxlen;
array[LEGS] of int: maxlegs;
array[ARMS] of int: maxarms;
array[FACE] of int: maxface;
constraint assert(maxlegs[stand] >= maxlen, "maxlegs[stand] smaller than maxlen");
constraint assert(maxarms[neutral] >= maxlen, "maxarms[neutral] smaller than maxlen");
constraint assert(maxface[blank] >= maxlen, "maxface[blank] smaller than maxlen");
array[LEGS,ARMS] of int: dance_value;
array[ARMS,FACE] of int: entice_value;
constraint assert(dance_value[stand,neutral] = 0, "incorrect dance_value array");
constraint assert(entice_value[neutral,blank] = 0, "incorrect entice_value array");
int: boredom; % how bored each step make the viewer

var STEP: len;
array[STEP] of var LEGS: legs;
array[STEP] of var ARMS: arms;
array[STEP] of var FACE: face;

% LEG FA
% array[1..7, LEGS] of 0..7: legs_fa =
%   [|2,0,4,5,6,7
%    |0,0,0,5,6,7
%    |2,0,4,0,0,7
%    |2,0,4,0,6,7
%    |2,0,4,0,0,7
%    |0,3,0,0,0,0
%    |2,0,4,5,6,0|];

array[1..7, LEGS] of 0..7: legs_fa =
  [|2,0,4,5,6,7    % start state 1
   |0,0,0,5,6,7    % spin        2
   |2,0,4,0,0,7    % leap        3
   |2,0,4,0,6,7    % waltz       4
   |2,0,4,5,0,7    % curtsey     5
   |2,3,4,5,6,7    % prep        6
   |2,0,4,5,6,7|]; % stand       7

constraint regular(legs, 7, 6, legs_fa, 1, 2..7);

% ARMS FA
array[1..6, ARMS] of 0..6: arms_fa =
 [|0,3,4,5,6       % init        1
  |0,3,4,5,6       % beckon      2
  |2,0,4,0,6       % out         3
  |2,3,0,0,6       % up          4
  |0,3,4,0,6       % wrapped     5
  |0,3,4,5,6|];    % neutral     6

constraint regular(arms, 6, 5, arms_fa, 1, 2..6);

% FACE FA
array[1..7, FACE] of 0..7: face_fa =
  [|2,3,4,5,6,7    % init        1
   |2,3,4,0,6,7    % smile       2
   |2,3,4,5,6,7    % wink        3
   |2,3,4,0,6,7    % batt        4
   |2,3,4,5,6,7    % think       5
   |2,3,4,5,6,7    % glow        6
   |2,3,4,5,6,7|]; % blank       7

constraint regular(face, 7, 6, face_fa, 1, 2..7);

constraint forall(i in 1..len-3)
  (legs[i]= waltz /\ legs[i+1]= waltz /\ legs[i+2]= waltz -> legs[i+3] != waltz);
constraint forall(i in 1..len-2)
    (
      (arms[i] = neutral /\ arms[i+1] = neutral -> arms[i+2] != neutral) /\
      (face[i] = face[i+1] /\ face[i] != blank -> face[i+2] != face[i])
    );

constraint forall(i,j in 1..len where i < j)
  (legs[i] = waltz /\ legs[j] = curtsey -> exists(k in i+1..j-1)
      (legs[k] = stand));

% GLOBALS
constraint global_cardinality_low_up(legs, LEGS, [0,0,0,0,0,0], maxlegs);
constraint global_cardinality_low_up(arms, ARMS, [0,0,0,0,0,0], maxarms);
constraint global_cardinality_low_up(face, FACE, [0,0,0,0,0,0], maxface);
% constraint global_cardinality_low_up(legs, LEGS, [0 | i in STEP], maxlegs);
% constraint global_cardinality_low_up(arms, ARMS, [0 | i in ARMS], maxarms);
% constraint global_cardinality_low_up(face, FACE, [0 | i in FACE], maxface);

% LEN CONSTRAINTS
% constraint sum(i in 1..maxlen)(arms[i] != neutral /\ legs[i] != stand /\ face[i] != blank) = len;
constraint forall(i in len+1..maxlen)
  (arms[i] = neutral /\ legs[i] = stand /\ face[i] = blank);

% FORBIDDEN COMBINATIONS
% constraint forall(i in 1..len)
%   (
%     (dance_value[legs[i], arms[i]] = -1 -> legs[i] != LEGS[legs[i]] /\ arms[i] != ARMS[arms[i]]) /\
%     (entice_value[arms[i], face[i]] = -1 -> arms[i] != ARMS[arms[i]] /\ face[i] != FACE[face[i]])
%   );

constraint forall(s in STEP) (dance_value[legs[s], arms[s]] >= 0);
constraint forall(s in STEP) (entice_value[arms[s], face[s]] >= 0);

% ARMS & LEGS COMBINATIONS -> VALUE
var int: value;
constraint sum(i in 1..len)
  (dance_value[legs[i], arms[i]]) = value;

% ARMS & FACE -> ENTICEMENT
var int: enticement;
constraint sum(i in 1..len)
  (entice_value[arms[i], face[i]]) = enticement;

% OBJECTIVE: VALUE + ENTICEMENT - DANCE_LENGTH*BOREDOM
var int: obj = value + enticement - len*boredom;

solve maximize obj;

output ["len = \(len);\nlegs = \(legs);\narms = \(arms);\nface = \(face);\nobj = \(obj);"];

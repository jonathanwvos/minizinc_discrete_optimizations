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

% LEG CONSTRAINTS
enum LEGS_EXTENDED = {sp, l, w1, w2, w3, c, p, st};
array[STEP] of var LEGS_EXTENDED: legs_extended;
array[LEGS_EXTENDED] of LEGS: leg_fa_translation = [spin, leap, waltz, waltz, waltz, curtsey, prep, stand];

array[1..9, LEGS_EXTENDED] of 0..9: leg_fa =
  [|2,0,4,5,6,7,8,9
   |0,0,0,0,0,7,8,9
   |2,0,4,0,0,0,0,9
   |2,0,0,5,0,0,8,9
   |2,0,0,0,6,0,8,9
   |2,0,0,0,0,0,8,9
   |2,0,4,0,0,0,0,9
   |0,3,0,0,0,0,0,0
   |2,0,4,0,0,7,8,0|];

constraint regular(legs_extended, 9, 8, leg_fa, 1, {9});
constraint forall(i in STEP)
  (legs[i] = leg_fa_translation[legs_extended[i]]);
constraint forall(i in 1..len-2)
  (legs[i] = waltz /\ legs[i+2] = curtsey -> legs[i+1] = stand);
% MAX LEG CONSTRAINT
constraint global_cardinality_low_up(legs, LEGS, [0,0,0,0,0,0], maxlegs);

% ARMS CONSTRAINTS
enum ARMS_EXTENDED = {b, o, u, wr, n1, n2};
array[STEP] of var ARMS_EXTENDED: arms_extended;
array[ARMS_EXTENDED] of ARMS: arms_fa_translation = [beckon, out, up, wrapped, neutral, neutral];

array[1..7, ARMS_EXTENDED] of 0..7: arms_fa =
  [|0,3,4,5,6,0
   |0,3,4,5,6,0
   |2,0,4,0,5,0
   |2,3,0,0,6,0
   |0,3,4,0,6,0
   |0,3,4,5,0,7
   |0,3,4,5,0,0|];

constraint regular(arms_extended, 7, 6, arms_fa, 1, {6});
constraint forall(i in STEP)
  (arms[i] = arms_fa_translation[arms_extended[i]]);
% MAX ARM CONSTRAINT
constraint global_cardinality_low_up(arms, ARMS, [0,0,0,0,0,0], maxarms);

% FACE CONTRAINTS
enum FACE_EXTENDED = {s, wi, ba, t, g, bl1, bl2};
array[STEP] of var FACE_EXTENDED: face_extended;
array[FACE_EXTENDED] of FACE: face_fa_translation = [smile, wink, batt, think, glow, blank, blank];

array[1..8, FACE_EXTENDED] of 0..8: face_fa =
  [|2,3,4,5,6,7,0
   |0,3,4,0,6,7,0
   |2,0,4,5,6,7,0
   |2,3,0,0,6,7,0
   |2,3,4,0,6,7,0
   |2,3,4,5,0,7,0
   |2,3,4,5,6,0,8
   |2,3,4,5,6,0,0|];

constraint forall(i in STEP)
  (face[i] = face_fa_translation[face_extended[i]]);
constraint regular(face_extended, 8, 7, face_fa, 1, {7});
% MAX FACE CONSTRAINT
constraint global_cardinality_low_up(face, FACE, [0,0,0,0,0,0], maxface);

% ARMS & LEGS COMBINATIONS -> VALUE
var int: value;
constraint sum(i in STEP)
  (dance_value[legs[i], arms[i]]) = value;

% ARMS & FACE -> ENTICEMENT
var int: enticement;
constraint sum(i in STEP)
  (entice_value[arms[i], face[i]]) = enticement;

constraint forall(i in len+1..maxlen)
  (arms[i] = neutral /\ legs[i] = stand /\ face[i] = blank);

% OBJECTIVE: VALUE + ENTICEMENT - DANCE_LENGTH*BOREDOM
var int: obj = value + enticement - len*boredom;

solve maximize obj;

output ["len = \(len);\nlegs = \(legs);\narms = \(arms);\nface = \(face);\nobj = \(obj);"];

include "alldifferent.mzn";
include "regular.mzn";

% PARAMETERS
enum DISH;
enum TASTE = {spicy, sour, salty, sweet, umame, bland};
enum TEMP = {hot, cold, warm};

array[DISH] of TASTE: taste;
array[DISH] of TEMP: temp;
array[DISH] of bool: heavy;
array[DISH] of int: value;

int: len; % length of banquet
set of int: COURSE = 1..len;
set of int: COURSE1 = 1..len-1;
set of int: COURSE2 = 1..len-2;

array[COURSE] of var DISH: dish;

% DECISIONS

%% INTERMEDIATES
array[COURSE] of var TASTE: tasteIndex;
array[COURSE] of var TEMP: tempIndex;
array[COURSE] of var bool: weightIndex;
array[COURSE] of var int: valueIndex;
var int: tasteSum;
var int: tempSum;
var int: weightSum;
var int: valueSum;
var int: obj;

% CONSTRAINTS
% Each dish can only be served once
constraint alldifferent(dish);

% No two dishes of the same taste can be served in a row
% Spicy dish -> Next dish is bland or sweet
% Sour dish -> Next dish is bland or umame
% Sweet dish -> Next dish is not spicy or umame
constraint forall(i in COURSE)(
  (tasteIndex[i] = taste[dish[i]])/\
  (tempIndex[i] = temp[dish[i]])/\
  (weightIndex[i] = heavy[dish[i]])/\
  (valueIndex[i] = value[dish[i]])
);

% constraint forall(i in COURSE1)(
%   (tasteIndex[i] != tasteIndex[i+1]) /\
%   (
%     tasteIndex[i] = spicy -> tasteIndex[i+1] in { bland, sweet }
%   ) /\
%   (
%     tasteIndex[i] = sour -> tasteIndex[i+1] in { bland, umame }
%   ) /\
%   (
%     tasteIndex[i] = sweet -> tasteIndex[i+1] in  { sour, salty, bland}
%   )
% );

array[1..7, TASTE] of 0..7: taste_fa =
    [|0,0,4,0,0,0
     |0,0,0,5,0,7
     |0,0,0,0,6,7
     |2,3,0,5,6,7
     |0,3,4,0,0,7
     |2,3,4,5,0,7
     |2,3,4,5,6,0|];

constraint regular(tasteIndex, 7, 6, taste_fa, 1, {5});

% First dish must be salty
constraint taste[dish[1]] = salty;

% Last dish must be sweet
constraint taste[dish[len]] = sweet;

% Hot - Warm - Cold dish order
% No more than 2 heavy dishes in a row
constraint forall(i in COURSE2)(
  weightIndex[i] /\ weightIndex[i+1] -> not(weightIndex[i+2])
);

% constraint forall(i in COURSE1)(
%   tempIndex[i] = hot -> forall(j in i+1..len)
%     (tempIndex[j] = cold -> exists(k in i+1..j-1)(tempIndex[k] = warm))
% );

array[1..2, TEMP] of 0..2: temp_fa =
  [|2,1,1
   |2,0,1|];

constraint regular(tempIndex, 2, 3, temp_fa, 1, {1,2});

% OBJ
% Maximize value AND no. of consecutive changes in taste, temperature and weight pairwise
constraint sum(i in COURSE1)(tasteIndex[i] != tasteIndex[i+1]) = tasteSum;
constraint sum(i in COURSE1)(tempIndex[i] != tempIndex[i+1]) = tempSum;
constraint sum(i in COURSE1)(weightIndex[i] != weightIndex[i+1]) = weightSum;
constraint sum(i in COURSE)(valueIndex[i]) = valueSum;
constraint sum([tasteSum, tempSum, weightSum, valueSum]) = obj;

solve maximize obj;

% RESULTS
output ["dish = \(dish);\nobj = \(obj);"];

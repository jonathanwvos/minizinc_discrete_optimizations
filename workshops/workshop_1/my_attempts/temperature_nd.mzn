array[int] of int: readings;
int: start;
int: n = length(readings);
set of int: TINDEX = 0..n;
set of int: RINDEX = 1..n;
array[TINDEX] of var int: temp;

constraint temp[0] = start;

constraint forall(i in RINDEX)
  (temp[i] = (readings[i] + temp[i-1]) div 2 );

solve satisfy;

output ["temp = \(temp)\n"];

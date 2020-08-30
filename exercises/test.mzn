array[1..3] of int: thing1 = [1,2,3];
% array[1..9] of int: thing2;

output [show(["\(i1),\(i2)" | i1, i2 in 1..3 where i1 != i2])];

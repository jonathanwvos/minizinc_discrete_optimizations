int: h = 4;
int: w = 4;

set of int: HEIGHT = 0..h;
set of int: CHEIGHT = 1..h-1;
set of int: WIDTH = 0..w;
set of int: CWIDTH = 1..w-1;

array[HEIGHT, WIDTH] of var float: t;

var float: left;
var float: right;
var float: bottom;
var float: top;

% Orthogonal constraints
constraint forall(i in CHEIGHT, j in CWIDTH)(4.0*t[i,j] = t[i-1,j] + t[i+1,j] + t[i,j-1] + t[i,j+1]);

% Edge constraints
constraint forall(j in CWIDTH)(t[0,j] = top); % top
constraint forall(j in CWIDTH)(t[h,j] = bottom); % bottom
constraint forall(i in CHEIGHT)(t[i,0] = left);% left
constraint forall(i in CHEIGHT)(t[i,w] = right);% right

% Corner constraints
constraint t[0,0] = 0.0;
constraint t[0,w] = 0.0;
constraint t[h,0] = 0.0;
constraint t[h,w] = 0.0;
left = 0.0;
right = 0.0;
bottom = 0.0;
top = 100.0;

solve satisfy;

output [ show_float(6, 2, t[i,j]) ++
         if j == w then "\n" else " " endif |
         i in HEIGHT, j in WIDTH
];

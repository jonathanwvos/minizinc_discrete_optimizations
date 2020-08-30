int: flour;
int: banana;
int: sugar;
int: butter;
int: cocoa;

constraint assert(flour >= 0, "Invalid datafile" ++
                              "Amount of flour should be non-negative");
constraint assert(banana >= 0, "Invalid datafile" ++
                              "Amount of banana should be non-negative");
constraint assert(sugar >= 0, "Invalid datafile" ++
                              "Amount of sugar should be non-negative");
constraint assert(butter >= 0, "Invalid datafile" ++
                              "Amount of butter should be non-negative");
constraint assert(cocoa >= 0, "Invalid datafile" ++
                              "Amount of cocoa should be non-negative");

var 0..100: b;
var 0..100: c;

constraint 250*b + 200*c <= flour;
constraint 2*b <= banana;
constraint 75*b + 150*c <= sugar;
constraint 100*b + 150*c <= butter;
constraint 75*c <= cocoa;

solve maximize 400*b + 450*c;

output ["No. of banana cakes: \(b)\tNo. of chocolate cakes: \(c)"];

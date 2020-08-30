enum Products;
array[Products] of int: profit;

enum Resources;

array[Resources] of int: capacity;

array[Products, Resources] of int: consumption;
constraint assert(forall(r in Resources, p in Products)(consumption[p,r] >= 0), "Error: Negative consumption");

int: mproducts = max(p in Products)
                  (min(r in Resources where consumption[p,r] > 0)
                    (capacity[r] div consumption[p,r]));

array[Products] of var 0..mproducts: produce;
array[Resources] of var 0..max(capacity): used;

constraint forall(r in Resources)(
  used[r] = sum(p in Products)(consumption[p,r]*produce[p])
);
constraint forall(r in Resources)(
  used[r] <= capacity[r]
);

solve maximize sum(p in Products)(profit[p]*produce[p]);

output ["\(p) = \(produce[p]);\n" | p in Products] ++
       ["\(r) = \(used[r]);\n" | r in Resources];

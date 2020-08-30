enum SOLDIER;
enum SHIFT;
int: nDays;
set of int: DAY = 1..nDays;
int: o;
int: l;
int: u;

array[SOLDIER,DAY] of var SHIFT: roster;

constraint forall(d in 1..(nDays-2), s in SOLDIER)(
  (roster[s,d] = NIGHT) /\ (roster[s,d+1] = NIGHT)
  -> (roster[s,d+2] != NIGHT));
constraint forall(d in 1..(nDays-1), s in SOLDIER)
  ((roster[s,d] = EVE) -> (roster[s,d+1] != NIGHT));
% constraint forall(day in DAY)
%   (sum(s in SOLDIER)
%     (roster[s,d] = NIGHT) = o);
% constraint forall(day in DAY)
%   (sum(s in SOLDIER)
%     (roster[s,d] = EVE) >= l);
% constraint forall(day in DAY)
%   (sum(s in SOLDIER)
%     (roster[s,d] = EVE) <= u);

constraint forall(day in DAY)
  (sum(s in SOLDIER)
    (roster[s,d] = NIGHT) = o);
constraint forall(day in DAY)
  (sum(s in SOLDIER)
    ((roster[s,d] = EVE) >= l) /\ ((roster[s,d] = EVE) <= u);

var int: tOnEve = sum(d in DAY)
  (sum(s in SOLDIER)(roster[s,d] = EVE));

solve maximize tOnEve;

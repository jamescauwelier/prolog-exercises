range_acc(Min, Min, Acc, [Min|Acc]) :- !.
range_acc(Min, Max, Acc, L) :-
  NextMax is Max - 1,
  range_acc(Min, NextMax, [Max|Acc], L).
range(Min, Max, R) :- range_acc(Min, Max, [], R).

append_2([], L, L).
append_2([H|T], L2, [H|L4]) :-
  append_2(T, L2, L4).

depth([], Acc, Acc).
depth([_|T], Acc, D) :-
  NewAcc is Acc + 1,
  depth(T, NewAcc, D).

min(A, B, A) :- A =< B.
min(A, B, B) :- A > B.

% Fringe implementations

  % queue
  add(queue([]), Elements, queue(Elements)).
  add(queue(L1), Elements, queue(L2)) :- append_2(L1, Elements, L2).
  add(stack([]), Elements, stack(Elements)).
  add(stack(L1), Elements, stack(L2)) :- append_2(Elements, L1, L2).

  % removes the next element from a datastructure

  remove(queue([]), _, _) :- fail.
  remove(queue([H|T]), H, queue(T)).
  remove(stack([]), _, _) :- fail.
  remove(stack([H|T]), H, stack(T)).

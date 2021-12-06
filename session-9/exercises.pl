% Trees

% t(L, X, R).

count(nil, 0).
count(t(L, _, R), C) :-
  count(L, LC),
  count(R, RC),
  C is 1 + LC + RC.

max(A, B, A) :- A > B.
max(A, B, B) :- B >= A.

depth(nil, 0).
depth(t(L, _, R), D) :-
  depth(L, LD),
  depth(R, RD),
  max(LD, RD, MD),
  D is MD + 1.

linearize(nil, []).
linearize(t(L, X, R), Linear) :-
  linearize(R, LinearR),
  linearize(L, LinearL),
  append_2(LinearL, [X|LinearR], Linear).

% TOO COMPLEX, SEE BETTER SOLUTION LATER

close_t(nil).
close_t(t(L, X, R)) :-
  var(L),
  L = nil,
  close_t(t(L, X, R)).
close_t(t(L, X, R)) :-
  not(var(L)),
  var(R),
  R = nil,
  close_t(t(L, X, R)).
close_t(t(L, _, R)) :-
  not(var(R)),
  not(var(L)),
  close_t(L),
  close_t(R).

% EASIER SOLUTION

close_t2(nil) :- !.
close_t2(t(L, x, R)) :-
  close(L),
  close(R).

% Efficiently sorting sorted lists

occur(_, []) :- fail.
occur(X, [X|_]) :- true,!.
occur(X, [H|_]) :- H >= X, fail, !.
occur(X, [H|T]) :- X \= H, occur(X, T).

occurthree(_, []) :- false, !.
occurthree(X, [H1, H2, H3 |_]) :-
  X < H3, !,
  occurthree(X, [H1, H2]).
occurthree(X, [_, _, H3 |T]) :- occurthree(X, [H3|T]).
occurthree(X, [X | _]) :- !.
occurthree(X, [_, X]) :- !.

% Binary dictionaries


sorted(nil).
sorted(T) :-
  linearize(T, L),
  is_sorted(L).
% sorted(t(t(_, XL, _), X, t(_, XR, _))) :-
%   XL < X,
%   XR > X,
%   sorted(t(_, XL, _)),
%   sorted(t(_, XR, _)).
% sorted(t(_, X, R)) :- R < X, !, fail.
% sorted(t(L, X, R)) :-
%   smaller_than(L, X),
%   larger_than(R, X).

% Balanced binary dictionaries

balanced(nil).
balanced(t(L, _, R)) :-
  depth(L, DL),
  depth(R, DR),
  Diff is DL - DR,
  print(Diff),nl,
  Diff =< 1, Diff >= -1,
  balanced(L),
  balanced(R).

% List length

list_length(L, R) :- list_length_2(L, R, 0).

list_length_2([], R, R).
list_length_2([_|T], R, Acc) :-
  NewAcc is Acc + 1,
  list_length_2(T, R, NewAcc).

% Rewrite quicksort

% quicksort([], []).
% quicksort([X | Tail], Sorted):-
% 	split(X, Tail, Small, Big),
% 	quicksort(Small, SortedSmall),
% 	quicksort(Big, SortedBig),
% 	conc(SortedSmall, [X| SortedBig], Sorted).

split(_, [], [], []).
split(X, [Y| Tail], [Y | Small], Big):-
	X > Y, !,
	split(X, Tail, Small, Big).
split(X, [Y| Tail], Small, [Y | Big]):-
	split(X, Tail, Small, Big).

% quicksort_acc([], [], [], []).
% quicksort_acc([], Sorted, SortedLeft, SortedRight).
quicksort_acc([], Sorted, Sorted).
quicksort_acc([X|Tail], SortedSmall, PartialSort) :-
  split(X, Tail, Small, Big),
  quicksort_acc(Big, SortedBig, PartialSort),
  quicksort_acc(Small, SortedSmall, [X|SortedBig]).

% Faster Fibonacci

% fib(N, F) :-
%   (N = 1 ; N = 2),
%   F is 1.
%
% fib(N, F) :-
%   N1 is N - 1,
%   N2 is N - 2,
%   fib(N1, F1),
%   fib(N2, F2),
%   F is F1 + F2.

% fib(N, F, 0, 0) :-

fib(1, F, P1, P2) :- F is P1 + P2.
fib(2, F, P1, P2) :- F is P1 + P2 + 1.
fib(N, F, 0, 0) :-
  N > 2,
  NextN is N - 1,
  fib(NextN, F, 1, 0).
fib(N, F, 0, 0) :-
  NextN is N - 1,
  fib(NextN, F, 1, 0).
fib(N, F, 1, 0) :-
  NextN is N - 1,
  fib(NextN, F, 1, 1).
fib(N, F, P1, P2) :-
  % N > 0,
  % P1 > 0,
  NextN is N - 1,
  P3 is P1 + P2,
  fib(NextN, F, P2, P3).


% At least twice

get_doubles(L, Doubles) :- get_doubles_acc(L, Doubles, [], []).

% get_doubles_acc([H|T], Result, Singles, Doubles) :-
%   member(H, Doubles),
%   get_doubles_acc(T, Result, Singles, Doubles).

% get_doubles_acc([H|T], Result, Singles, Doubles) :-
%   not(member(H, Singles)),
%   get_doubles_acc(T, Result, [H|Singles], Doubles).

get_doubles_acc([H|T], Result, Singles, Doubles) :-
  member(H, Singles),
  get_doubles_acc(T, Result, Singles, [H|Doubles]).


% Find the first element in a list

% first(false, []). DOES NOT NEED TO BE DEFINED!!!

first(H, [H|_]).

% Find the last element of a list

% last(false, []). DOES NOT NEED TO BE DEFINED!!!
last(H, [H|[]]).
last(L, [_|T]) :- last(L, T).

% Removing in a list one element equal to T: remove(T, List, NewList)

remove(_, [], []).
remove(D, [D|T1], T1).
remove(D, [H|T1], [H|T2]) :-
	D \= H,
	remove(D, T1, T2).


% Removing in a list ALL elements equal to T: remove_all(T, List, NewList)

remove_all(_, [], []).
remove_all(D, [D|T1], T2) :-
	remove_all(D, T1, T2).
remove_all(D, [H|T1], [H|T2]) :-
	D \= H,
	remove_all(D, T1, T2).

% Removing in a list of numbers all elements smaller than or equal to N: smaller(N, NumberList, NewNumberList)

smaller(_, [], []).

smaller(N, [O|T1], T2) :-
	O =< N,
	smaller(N, T1, T2).
smaller(N, [O|T1], [O|T2]) :-
	O > N,
	smaller(N, T1, T2).


% Switching the first two elements of a list: switch_first_two(List, NewList). For example a call to switch_first_two([a,b,c,d,e,f], L) should return L = [b,a,c,d,e,f]

switch_first_two([], []).
switch_first_two([N], [N]).
switch_first_two([N1, N2|T],[N2, N1|T]).

% Switching every pair of elements in a list: switch_every_two(List, NewList). For example a call to switch_every_two([a,b,c,d,e,f,g], L) should return L = [b,a,d,c,f,e,g]

switch_every_two([], []).
switch_every_two([N],[N]).
switch_every_two([N1, N2|T1],[N2,N1|T2]) :-
	switch_every_two(T1,T2).


/*
Exercise 2: SORTING A LIST
*/

switch_unsorted([],[]).
switch_unsorted([N], [N]).
switch_unsorted([N1, N2|T], [N2, N1|T]) :- N1 > N2.
switch_unsorted([N1, N2|T1], [N1|T2]) :-
	N1 =< N2,
	switch_unsorted([N2|T1], T2).

ten_times(NL0, NL10):-
	switch_unsorted(NL0, NL1),
	switch_unsorted(NL1, NL2),
	switch_unsorted(NL2, NL3),
	switch_unsorted(NL3, NL4),
	switch_unsorted(NL4, NL5),
	switch_unsorted(NL5, NL6),
	switch_unsorted(NL6, NL7),
	switch_unsorted(NL7, NL8),
	switch_unsorted(NL8, NL9),
	switch_unsorted(NL9, NL10).


ten_times_easier(NL1, NL1, 0).
ten_times_easier(NL1, NL3, R1) :-
  R1 \= 0,
	R2 is R1 - 1,
	switch_unsorted(NL1, NL2),
	ten_times_easier(NL2, NL3, R2).

is_sorted([]) :- true.
is_sorted([_]) :- true.
is_sorted([N1, N2|_]) :-
	N1 > N2,
	false.
is_sorted([N1, N2|T]) :-
	N1 =< N2,
	is_sorted([N2|T]).

sort_me(L1, L1) :- is_sorted(L1).
sort_me(L1, L3) :-
	not(is_sorted(L1)),
	switch_unsorted(L1, L2),
	sort_me(L2, L3).

/*
EXERCISE 3: NESTED LISTS
*/

flatten([], []).
flatten([[H1|TL2]|TL1], AL) :-
	flatten(TL1, TL3),
	append([H1|TL2], TL3, AL).
flatten([H|T], AL) :-
	flatten(T, T2),
	append([H], T2, AL).

is_list([]).
is_list([_|T]) :- is_list(T).

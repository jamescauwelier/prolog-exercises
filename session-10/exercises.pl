% Merge sort

% First, we write sorting specs with semantics of our problem attached

% for move(M, P, O)
% P = player piece count
% O = opponent piece count

% moves that have more player pieces come before others
before(move(_, P1, _), move(_, P2, _)) :- P1 > P2.
before(move(_, P1, O1), move(_, P2, O2)) :- P1 = P2, O1 < O2.

% for numbers
before(N1, N2) :- number(N1), number(N2), N1 =< N2.

% ?-merge([3,5,8],[1,3,4,6,7,12,28],L).
% L = [1,3,3,4,5,6,7,8,12,28]

merge([], [], []).
merge([], L2, L2).
merge(L1, [], L1).
merge([H1|T1], [H2|T2], [H1|MergedT]) :-
  before(H1, H2),
  merge(T1, [H2|T2], MergedT).

merge([H1|T1], [H2|T2], [H2|MergedT]) :-
  not(before(H1, H2)),
  merge([H1|T1], T2, MergedT).

% ?-split([1,17,5,3,9],L,R).
% L = [1, 5, 9]
% R = [17, 3]

split([], [], []).
split([H1], [H1], []).
split([H1, H2|T], [H1|TL1], [H2|TL2]) :-
  split(T, TL1, TL2),!.

% ?- mergesort([23,2,1,3,1],L).
% L = [1,1,2,3,23]

% E.g. ?- mergesort([move(h2h4,5,6), move(c2d3,5,5), move(a6f6,6,6)],L).
% results in L = [move(a6f6,6,6),move(c2d3,5,5),move(h2h4,5,6)]
% Try to adapt the mergesort predicate that you have just written in order to
% do this. Do you need to change the predicate a lot?

% these work regardless of the type of structure present
mergesort([], []).
mergesort([H], [H]).

% a customized 'before' allows us to abstract comparison depending on the
% structure matchedz
mergesort([H1, H2], [H1, H2]) :- before(H1, H2).
mergesort([H1, H2], [H2, H1]) :- not(before(H1, H2)).

% implementation of the sort
mergesort(IL, OL) :-
  split(IL, SplitLeft, SplitRight),
  mergesort(SplitLeft, SortedSplitLeft),
  mergesort(SplitRight, SortedSplitRight),
  merge(SortedSplitLeft, SortedSplitRight, OL),!.

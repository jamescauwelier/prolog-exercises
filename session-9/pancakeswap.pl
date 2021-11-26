% Pancake flipping challenge

% Generating problems

countToN(0, R, R).
countToN(N, R, Acc) :-
  N > 0,
  K is N - 1,
  countToN(K, R, [N|Acc]).

permutation([], P, P).
permutation(L1, P, Acc) :-
  member(M, L1),
  delete(L1, M, L2),
  permutation(L2, P, [M|Acc]).

generateStacksOfSize(Size, Stacks) :-
  countToN(Size, SortedStack, []),
  findall(P, permutation(SortedStack, P, []), Stacks).

% naive Solution

reverse(L, I) :- reverse_acc(L, I, []).
reverse_acc([], I, I).
reverse_acc([H|T], I, Acc) :-
  reverse_acc(T, I, [H|Acc]).

flip(L1, L2) :-
  append(Part1, Part2, L1),
  proper_length(Part1, Part1Length),
  Part1Length > 1,
  reverse(Part1, Part1Inverted),
  append(Part1Inverted, Part2, L2).

is_sorted([]).
is_sorted([_]).
is_sorted([H1, H2|_]) :- H1 >= H2, !, fail.
is_sorted([H1, H2|T]) :- H1 =< H2, is_sorted([H2|T]).

% For breadth-first search, a queue is used, so lets build that first

  % adds a new element to the end of the queue (basically just an append, but semantically explained better in the naming)

  queue_add([], Elements, Elements).
  queue_add(L1, Elements, L2) :- append(L1, Elements, L2).

  % removes the next element from the queue and returns the updated queue

  queue_remove([], _, _) :- fail.
  queue_remove([H|T], H, T).

% naive_flipper(Fringe, Solution).

  flipper(StackOfPancakes, FlippingSolution) :-
    % we use the pancake stack as the only element of a path to start from
    FirstPath = [StackOfPancakes],
    % to start, the fringe consists of just one path
    Fringe = [FirstPath],
    % execute breadth first search for a solution 
    flipper_breadth_first(Fringe, FlippingSolution).

  flipper_breadth_first([], _) :- fail.
  flipper_breadth_first(Fringe, [GoalState|PreviousStates]) :-
    queue_remove(Fringe, [GoalState|PreviousStates], _),
    is_sorted(GoalState),!.
  flipper_breadth_first(Fringe, Solution) :-
    % gets the next element to inspect
    queue_remove(Fringe, [CurrentState|PreviousStates], ShortenedFringe),
    % verifies that it is not fully sorted
    not(is_sorted(CurrentState)),
    % flip the stack of pancakes again when not sorted
    findall([F,CurrentState|PreviousStates], flip(CurrentState, F), NewStates),
    % after flipping, make sure to add this state to the queue
    queue_add(ShortenedFringe, NewStates, ExpandedFringe),
    print(ExpandedFringe), nl,
    % attempt to flip again on the next element in the fringe
    flipper_breadth_first(ExpandedFringe, Solution),!.

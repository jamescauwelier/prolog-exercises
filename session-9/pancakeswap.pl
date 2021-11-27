% Pancake flipping challenge

append_2([], L, L).
append_2([H|T], L2, [H|L4]) :-
  append_2(T, L2, L4).

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
  append_2(Part1, Part2, L1),
  proper_length(Part1, Part1Length),
  Part1Length > 1,
  reverse(Part1, Part1Inverted),
  append_2(Part1Inverted, Part2, L2).

is_sorted([]).
is_sorted([_]).
is_sorted([H1, H2|_]) :- H1 >= H2, !, fail.
is_sorted([H1, H2|T]) :- H1 =< H2, is_sorted([H2|T]).

% For breadth-first search, a queue is used, so lets build that first

  % adds a new element to the end of the queue (basically just an append, but semantically explained better in the naming)

  queue_add([], Elements, Elements).
  queue_add(L1, Elements, L2) :- append_2(L1, Elements, L2).

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

% depth-first pancake flipper

  % first we need a stack instead

    % adds a list of new elements to a stack

    add(stack([]), Elements, stack(Elements)).
    add(stack(L1), Elements, stack(L2)) :- append_2(L1, Elements, L2).

    % removes the next element from a stack

    remove(stack([]), _, _) :- fail.
    remove(stack([path(H)|T]), path(H), stack(T)).

    loop_free(path([])).
    loop_free(path([CurrentState|PreviousStates])) :-
      not(member(CurrentState, PreviousStates)).

    remove_loops([], LoopFreePaths, LoopFreePaths).
    remove_loops([path([CurrentState|PreviousStates])|OtherPaths], LoopFreePaths, Acc) :-
      loop_free(path([CurrentState|PreviousStates])),
      remove_loops(OtherPaths, LoopFreePaths, [path([CurrentState|PreviousStates])|Acc]).
    remove_loops([path([CurrentState|PreviousStates])|OtherPaths], LoopFreePaths, Acc) :-
      not(loop_free(path([CurrentState|PreviousStates]))),
      remove_loops(OtherPaths, LoopFreePaths, Acc).

  % then a new flipper

  flipper2(StackOfPancakes, FlippingSolution) :-
    % we use the pancake stack as the only element of a path to start from
    FirstPath = [StackOfPancakes],
    % to start, the fringe consists of just one path
    Fringe = [FirstPath],
    % execute breadth first search for a solution
    flipper_breadth_first(Fringe, FlippingSolution).

  % and a new implementation

  flipper_depth_first([], _) :- fail.
  flipper_depth_first(Fringe, path([GoalState|PreviousStates])) :-
    remove(Fringe, path([GoalState|PreviousStates]), _),
    is_sorted(GoalState),!.
  flipper_depth_first(stack(Fringe), Solution) :-
    % gets the next element to inspect
    remove(stack(Fringe), path([CurrentState|PreviousStates]), stack(ShortenedFringe)),
    % verifies that it is not fully sorted
    not(is_sorted(CurrentState)),
    % flip the stack of pancakes again when not sorted
    findall(path([F,CurrentState|PreviousStates]), flip(CurrentState, F), NewPaths),
    remove_loops(NewPaths, NewLoopFreePaths, []),
    % after flipping, make sure to add this state to the queue
    add(stack(ShortenedFringe), NewLoopFreePaths, ExpandedFringe),
    print(ExpandedFringe), nl,
    % attempt to flip again on the next element in the fringe
    flipper_depth_first(ExpandedFringe, Solution),!.

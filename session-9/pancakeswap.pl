% Pancake flipping challenge

  % first we define some utilities

    % implementing a simple append function

    append_2([], L, L).
    append_2([H|T], L2, [H|L4]) :-
      append_2(T, L2, L4).

    % generates lists with counters of 1..n

    countToN(0, R, R).
    countToN(N, R, Acc) :-
      N > 0,
      K is N - 1,
      countToN(K, R, [N|Acc]).

    % generates permutations of any list

    permutation([], P, P).
    permutation(L1, P, Acc) :-
      member(M, L1),
      delete(L1, M, L2),
      permutation(L2, P, [M|Acc]).

    % with the above, we can now generate any random stack of pancakes

    generateStacksOfSize(Size, Stacks) :-
      countToN(Size, SortedStack, []),
      findall(P, permutation(SortedStack, P, []), Stacks).

    % reversing a full list (important for the flipping action)

    reverse(L, I) :- reverse_acc(L, I, []).
    reverse_acc([], I, I).
    reverse_acc([H|T], I, Acc) :-
      reverse_acc(T, I, [H|Acc]).

    % generates ways of flipping a stack of pancakes

    flip(L1, L2) :-
      append_2(Part1, Part2, L1),
      proper_length(Part1, Part1Length),
      Part1Length > 1,
      reverse(Part1, Part1Inverted),
      append_2(Part1Inverted, Part2, L2).

    % the end goal of the pancake swapping is a fully sorted stack, so here we test for that

    is_sorted([]).
    is_sorted([_]).
    is_sorted([H1, H2|_]) :- H1 > H2, !, fail.
    is_sorted([H1, H2|T]) :- H1 =< H2, is_sorted([H2|T]).

% depth-first pancake flipper

  % underlying data structure

    % adds a list of new elements to a datastructure

      % stack
      add(stack([]), Elements, stack(Elements)).
      add(stack(L1), Elements, stack(L2)) :- append_2(Elements, L1, L2).

      % queue
      add(queue([]), Elements, queue(Elements)).
      add(queue(L1), Elements, queue(L2)) :- append_2(L1, Elements, L2).

    % removes the next element from a datastructure

      % stack

      remove(stack([]), _, _) :- fail.
      remove(stack([path(H)|T]), path(H), stack(T)).

      % queue

      remove(queue([]), _, _) :- fail.
      remove(queue([path(H)|T]), path(H), queue(T)).

    % loop-checking is datastructure independent

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

  % Can we make this polymorphic?

    % Start by abstracting the manipulations over the data structures

      % for implementation, see above as these need to be together!!!

    % Then adapt the algorithm to remove references to a specific data structure

    flipper_poly([], _) :- fail.
    flipper_poly(Fringe, path([GoalState|PreviousStates])) :-
      remove(Fringe, path([GoalState|PreviousStates]), _),
      is_sorted(GoalState),!.
    flipper_poly(Fringe, Solution) :-
      % gets the next element to inspect
      remove(Fringe, path([CurrentState|PreviousStates]), ShortenedFringe),
      % verifies that it is not fully sorted
      not(is_sorted(CurrentState)),
      % flip the stack of pancakes again when not sorted
      findall(path([F,CurrentState|PreviousStates]), flip(CurrentState, F), NewPaths),
      remove_loops(NewPaths, NewLoopFreePaths, []),
      % after flipping, make sure to add this state to the queue
      add(ShortenedFringe, NewLoopFreePaths, ExpandedFringe),
      print(ExpandedFringe), nl,
      % attempt to flip again on the next element in the fringe
      flipper_poly(ExpandedFringe, Solution),!.

    % implementations for depth-first and breadth-first

    flipper(FringeImplementation, StackOfPancakes, FlippingSolution) :-
      % we use the pancake stack as the only element of a path to start from
      FirstPath = path([StackOfPancakes]),
      % the fringe is composed of the implementation (stack or queue) and a list of paths
      Fringe =.. [FringeImplementation|[[FirstPath]]],
      % executing in the polymorphic flipper
      flipper_poly(Fringe, FlippingSolution).

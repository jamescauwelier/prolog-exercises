
% Alternative state: t(M, C, PositionBoat)
% t(3,3,left) -> right has (0,0)
% - t(1,3,right) --> X
% - t(3,1,right)
% - - t(3,1,left)
% - - - t()
% - - t(2,2,left)

% we only board on the left bank and when there is space on the boat

  % we can board missionaries if there are left standing at the left bank
  actions(river(group(M/_), boat(group(BM/BC), left), _), board(group(1/0))) :-
    TotalBoat is BM + BC,
    TotalBoat < 2,
    M > 0.

  % we can board cannibals if there are left standing at the left bank
  actions(river(group(_/C), boat(group(BM/BC), left), _), board(group(0/1))) :-
    TotalBoat is BM + BC,
    TotalBoat < 2,
    C > 0.

% we can fully unboard with nothing left on the left bank and we only unboard
% on the right bank

  actions(river(_, boat(group(BM/_), right), _), unboard(group(1/0))) :-
    BM > 0.

  actions(river(_, boat(group(_/BC), right), _), unboard(group(0/1))) :-
    BC > 0.

% river crossing actions

  % we only cross from left -> right when the boat is full
  actions(river(_, boat(group(BM/BC), left), _), cross_river()) :-
    TotalBoat is BM + BC,
    TotalBoat = 2.

  % we only cross from right to left when there is one free spot in the boat
  actions(river(_, boat(group(BM/BC), right), _), cross_river()) :-
    TotalBoat is BM + BC,
    TotalBoat = 1.

% SEARCH

  test(FringeType, S) :-
    FirstState = river(group(3/3), boat(group(0/0), left), group(0/0)),
    FirstTrace = [FirstState],
    Fringe =.. [FringeType, [FirstTrace]],
    search(Fringe, S).

  % no more valid traces to explore
  % search(queue([]), no_solution).

  print_trace([]).
  print_trace([State|StateHistory]) :-
    print(State),nl,print_trace(StateHistory).

  % return solutions when selecting from the queue
  search(Fringe, SolutionTrace) :-
    remove(Fringe, CurrentTrace, _),
    is_solution(CurrentTrace),
    print_trace(CurrentTrace),nl,
    SolutionTrace=CurrentTrace.

  % expand the queue with new traces in a breadth first manner
  search(Fringe, SolutionTrace) :-
    remove(Fringe, CurrentTrace, ReducedQueue),
    not(is_solution(CurrentTrace)),
    % if no solution is found, expand the fringe
    findall(Expansion, expand(CurrentTrace, Expansion), Expansions),
    add(ReducedQueue, Expansions, ExpandedQueue),
    search(ExpandedQueue, SolutionTrace).

  expand([CurrentState|TraceHistory], [NewState,CurrentState|TraceHistory]) :-
    % what are the possible actions to take?
    actions(CurrentState, Action),
    % execute those against the current state
    execute(Action, CurrentState, NewState),
    % validate they lead to a valid new state
    validate_state(NewState),
    % validate the state is a new state within the current trace
    no_loop(NewState, [CurrentState|TraceHistory]).

% succeeds if all persons have crossed the river
is_solution([river(_,_,group(3/3))|_]) :- !.

% group(M, C).

with(group(M1/C1), group(M2/C2), group(M3/C3)) :-
  M3 is M1 + M2,
  C3 is C1 + C2.

without(group(M1/C1), group(M2/C2), group(M3/C3)) :-
  M3 is M1 - M2,
  C3 is C1 - C2.


% (UN)BOARD ACTIONS

  % board when the boat is at the left bank

  execute(
      board(BoardingGroup),
      river(
        LeftGroup,
        boat(BoatGroup, left),
        RightGroup
      ),
      river(
        NewLeftGroup,
        boat(NewBoatGroup, left),
        RightGroup
      )
    ) :-
      without(LeftGroup, BoardingGroup, NewLeftGroup),
      with(BoatGroup, BoardingGroup, NewBoatGroup).

  % unboard when the boat is at the right bank

  execute(
      unboard(BoardingGroup),
      river(
        LeftGroup,
        boat(BoatGroup, right),
        RightGroup
      ),
      river(
        LeftGroup,
        boat(NewBoatGroup, right),
        NewRightGroup
      )
    ) :-
      with(RightGroup, BoardingGroup, NewRightGroup),
      without(BoatGroup, BoardingGroup, NewBoatGroup).

% RIVER CROSSING ACTIONS

  % since we are matching the boat group on [H|T],
  % empty groups are not allowed

  % crossing left -> right

  execute(
    cross_river(),
    river(
      LeftGroup,
      boat(BoatGroup, left),
      RightGroup
    ),
    river(
      LeftGroup,
      boat(BoatGroup, right),
      RightGroup
    )
  ).

  % crossing right -> left

  execute(
    cross_river(),
    river(
      LeftGroup,
      boat(BoatGroup, right),
      RightGroup
    ),
    river(
      LeftGroup,
      boat(BoatGroup, left),
      RightGroup
    )
  ).

% generates available actions and executes them

try_action(
  CurrentState, Action, NewState
) :-
  actions(CurrentState, Action),
  execute(Action, CurrentState, NewState).

% validate state

valid_group(group(M/_)) :- M = 0,!.
valid_group(group(M/C)) :-
  M > 0,
  M >= C,!.

validate_state(
  river(
    group(LM/LC),
    boat(group(BM/BC), _),
    group(RM/RC)
  )
) :-
  % the boat only seats two
  BoatOccupancy is BM + BC,
  BoatOccupancy =< 2,
  % nowhere can there be more cannibals than missionaries
  valid_group(group(LM/LC)),
  % valid_group(group(BM, BC)),
  valid_group(group(RM/RC)).

no_loop(CurrentState, Trace) :- not(member(CurrentState, Trace)).

% water jugs

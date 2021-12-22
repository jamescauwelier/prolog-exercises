
% jug(0/15)
% jug(0/16)

% ACTIONS

fill(j(_/Capacity), j(Capacity/Capacity)).
empty(j(_/Capacity),j(0/Capacity)).
transfer(
  j(ContentsA/CapacityA),
  j(ContentsB/CapacityB),
  j(NewContentsA/CapacityA),
  j(MaxNewContentsB/CapacityB)
  ) :-
  NewContentsB is ContentsA + ContentsB,
  min(NewContentsB, CapacityB, MaxNewContentsB),
  AddedToB is MaxNewContentsB - ContentsB,
  NewContentsA is ContentsA - AddedToB.

try_expand([X,Y],[Z, Y]) :- fill(X, Z).
try_expand([X,Y],[X,Z]) :- fill(Y,Z).
try_expand([X,Y],[Z, Y]) :- empty(X, Z).
try_expand([X,Y],[X,Z]) :- empty(Y,Z).
try_expand([X1,Y1],[X2, Y2]) :- transfer(X1, Y1, X2, Y2).
try_expand([X1,Y1],[X2, Y2]) :- transfer(Y1, X1, Y2, X2).

% example state: [j(0/15),j(0/16)]

% whenever there is a jug with 8l, we reach goal
is_goal(S, GoalVolume) :- member(j(GoalVolume/_), S).

next(N, M) :- M is N+1.

% waterjugs(MaxDepth) :-
%

natural(1).
natural(N) :-
  natural(F),
  N is F + 1.

% Examples:
% ?- test([j(0/3),j(0/4)], 2).
% ?- test([j(0/15),j(0/16)], 8).


% jugs = [j(0/15),j(0/16)]
% GoalVolume = 8
test(Jugs, GoalVolume) :-
  Trace = [Jugs],
  natural(TraceLimit),
  print('Depth='),print(TraceLimit),nl,
  find_plan(GoalVolume, Trace, TraceLimit, SolutionTrace),!,
  print(SolutionTrace).

find_plan(GoalVolume, [State|TraceHistory], _, [State|TraceHistory]) :-
  is_goal(State, GoalVolume),!.

find_plan(GoalVolume, [State|StateTrace], TraceLimit, GoalState) :-
  depth([State|StateTrace], 0, TraceDepth),
  TraceDepth < TraceLimit,
  try_expand(State, NewState),
  NewTrace = [NewState, State | StateTrace],
  loop_free(NewTrace),
  find_plan(GoalVolume, NewTrace, TraceLimit, GoalState).

loop_free([State|StateTrace]) :- not(member(State, StateTrace)).

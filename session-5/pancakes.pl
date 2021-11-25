% flip pancakes until sorted small to large
% flipping can only be done leftmost
% example [1547632]

% invert(L, I)

invertOp([], RL, RL).
invertOp([LH], RL, [LH|RL]).
invertOp([LH|LT], RL, [ILT|[LH|RL]]) :-
  invertOp(LT, [], ILT).

invert([], []).
invert([H|[Last]], [Last|[H]]).
invert([H|T], [IT|[H]]) :-
  invert(T, IT).

% %
% % length_acc([], L, L).
% % length_acc([_|T], Acc, L) :-
% %   NewAcc is Acc + 1,
% %   length_acc(T, NewAcc, L).
% %
% % length2(List, Length) :- length_acc(List, 0, Length).
%
% range_acc(Min, Min, Acc, [Min|Acc]) :- !.
% range_acc(Min, Max, Acc, L) :-
%   NextMax is Max - 1,
%   range_acc(Min, NextMax, [Max|Acc], L).
% range(Min, Max, R) :- range_acc(Min, Max, [], R).
%
% append_2([], L, L).
% append_2([H|T], L2, [H|L4]) :-
%   append_2(T, L2, L4).
%
% min(A, B, A) :- A =< B.
% min(A, B, B) :- A > B.
%
% % queue
% add(queue([]), Elements, queue(Elements)).
% add(queue(L1), Elements, queue(L2)) :- append_2(L1, Elements, L2).
% add(stack([]), Elements, stack(Elements)).
% add(stack(L1), Elements, stack(L2)) :- append_2(Elements, L1, L2).
%
% % removes the next element from a datastructure
%
% remove(queue([]), _, _) :- fail.
% remove(queue([H|T]), H, queue(T)).
% remove(stack([]), _, _) :- fail.
% remove(stack([H|T]), H, stack(T)).
%
% % setup(3/3, 0/0, 0/0)
%
% actions(river(group(M/C), boat(BM/BC, left), _), board(m)) :-
%   TotalBoat is BM + BC,
%   TotalBoat < 2,
%   M > 0.
%
% actions(river(group(M/C), boat(BM/BC, left), _), board(c)) :-
%   TotalBoat is BM + BC,
%   TotalBoat < 2,
%   C > 0.
%
% % we can fully unboard with nothing left on the left bank
%
%   actions(river(group(0/0), boat(BM/BC, right), _), unboard(m)) :-
%     BM > 0.
%
%   actions(river(group(0/0), boat(BM/BC, right), _), unboard(c)) :-
%     BC > 0.
%
% % we need 1 person on the boat for the return tripe when others are still
% % on the left bank
%
%   actions(river(group(LM/LC), boat(BM/BC, right), _), unboard(m)) :-
%     LeftBankCount is LM + LC,
%     LeftBankCount > 0,
%     BoatCount is BM + BC,
%     BoatCount = 2,
%     BM > 0.
%
%   actions(river(group(LM/LC), boat(BM/BC, right), _), unboard(c)) :-
%     LeftBankCount is LM + LC,
%     LeftBankCount > 0,
%     BoatCount is BM + BC,
%     BoatCount = 2,
%     BC > 0.
%
% % we can cross the river with at least 1 person in the boat
%
%   % but for crossing for the left, it makes sense only to cross with 2 inside
%   % in the other case, it would mean we haven't fully boarded or we just did a
%   % pointless return trip
%   actions(river(_, boat(BM/BC, left), _), cross_river()) :-
%     BoatCount is BM + BC,
%     BoatCount = 2.
%
%   % actions(river(_, boat(BM/BC, right), _), cross_river()) :-
%
%
% actions(river(_, boat(BM/BC, right), group(M/C)), unboard(m)) :-
%   TotalBoat is BM + BC,
%   TotalBoat > 1,
%   BM > 0.
%
% actions(river(_, boat(BM/BC, right), group(M/C)), unboard(c)) :-
%   TotalBoat is BM + BC,
%   TotalBoat > 1,
%   BC > 0.
%
% % search framework
%
% % solve(InitialState,Trace) :-
% %         search(InitialState,[InitialState],Trace).
% %
% % search(CurrentState,AccTrace,Trace):-
% %         is_solution(CurrentState),
% %         Trace=AccTrace.
% %
% % search(CurrentState,AccTrace,Trace):-
% %         try_action(CurrentState,NewState),
% %         validate_state(NewState),
% %         no_loop(NewState,AccTrace),
% %         search(NewState,[NewState|AccTrace],Trace).
%
% % SEARCH
%
%   test(FringeType, S) :-
%     FirstState = river(bank(group(3,3)), boat(group(0,0), left), bank(group(0,0))),
%     FirstTrace = [FirstState],
%     Fringe =.. [FringeType, [FirstTrace]],
%     search(Fringe, S).
%
%   % no more valid traces to explore
%   % search(queue([]), no_solution).
%
%   % return solutions when selecting from the queue
%   search(Fringe, SolutionTrace) :-
%     remove(Fringe, CurrentTrace, _),
%     print(CurrentTrace),nl,
%     is_solution(CurrentTrace),
%     % print(solved),nl,
%     SolutionTrace=CurrentTrace.
%
%   % expand the queue with new traces in a breadth first manner
%   search(Fringe, SolutionTrace) :-
%     % print(CurrentTrace), nl,
%     remove(Fringe, CurrentTrace, ReducedQueue),
%     not(is_solution(CurrentTrace)),
%     % if no solution is found, expand the fringe
%     findall(Expansion, expand(CurrentTrace, Expansion), Expansions),
%     add(ReducedQueue, Expansions, ExpandedQueue),
%     % print('Exps'),nl,
%     % print(Expansions),nl,
%     % pretty_print(ExpandedQueue), nl,
%     % print(ExpandedQueue),nl,
%     search(ExpandedQueue, SolutionTrace).
%
%   expand([CurrentState|TraceHistory], [NewState,CurrentState|TraceHistory]) :-
%     % print('Expanding...'),nl,
%     % print(CurrentState),nl,
%     % print('Actions found'),nl,
%     % what are the possible actions to take?
%     actions(CurrentState, Action),
%     % print(Action),nl,
%     % execute those against the current state
%     execute(Action, CurrentState, NewState),
%     % print(NewState),nl,
%     % validate they lead to a valid new state
%     validate_state(NewState),
%     % validate the state is a new state within the current trace
%     no_loop(NewState, [CurrentState|TraceHistory]).
%
% pretty_print(queue(Traces)) :-
%   print('Q: '),nl,pretty_print_traces(Traces).
%
% pretty_print_traces([H|T]) :-
%   print('- Trace'),nl,
%   pretty_print_trace(H),
%   pretty_print_traces(T).
%
% pretty_print_trace([H|T]) :-
%   print('-- '),print(H),nl,pretty_print_trace(T).
%
% % succeeds if all persons have crossed the river
% is_solution([river(_,_,group(3,3))|_]) :- !.
%
% % missionaries / cannibals
%
% % actions(
% %   % whenever the state concerns a river
% %   river(_, _, _),
% %   % we provide the actions related to manipulating a boat
% %   [
% %
% %     river_crossing(),
% %
% %     % boarding actions
% %     boarding(group(2,0)),
% %     boarding(group(1,1)),
% %     boarding(group(1,0)),
% %     boarding(group(0,1)),
% %     boarding(group(0,2)),
% %
% %     % unboarding actions
% %     unboarding(group(2,0)),
% %     unboarding(group(1,1)),
% %     unboarding(group(1,0)),
% %     unboarding(group(0,1)),
% %     unboarding(group(0,2))
% %   ]
% %   ).
%
% % can we generate only the valid actions?
%
% crossing_action_generator(
%   boat(group(BMissionaries, BCannibals), _),
%   river_crossing()
% ) :-
%   BoatOccupancy is BMissionaries + BCannibals,
%   BoatOccupancy > 0,!.
%
% unboarding_action_generator(
%   boat(group(BM, BC), right),
%   unboarding(group(MCount, CCount))
% ) :-
%   range(0, BM, MOptions),
%   range(0, BC, COptions),
%   member(MCount, MOptions),
%   member(CCount, COptions),
%   Total is MCount + CCount,
%   Total > 0.
%
% boarding_bank(
%   river(
%     bank(group(LMissionaries, LCannibals)),
%     boat(group(_, _), left),
%     bank(group(_, _))
%   ),
%   bank(group(LMissionaries, LCannibals))
% ).
%
% boarding_bank(
%   river(
%     bank(group(_, _)),
%     boat(group(_, _), right),
%     bank(group(RMissionaries, RCannibals))
%   ),
%   bank(group(RMissionaries, RCannibals))
% ).
%
% boarding_action_generator(
%   RiverState,
%   boarding(group(MToBoard, CToBoard))
% ) :-
%   boarding_bank(RiverState, bank(group(MOnTheBank, COnTheBank))),
%   RiverState = river(_, boat(group(MInTheBoat, CInTheBoat), _), _),
%   min(2, MOnTheBank, MaxBoardableM),
%   min(2, COnTheBank, MaxBoardableC),
%   range(0, MaxBoardableM, MBoardingOptions),
%   range(0, MaxBoardableC, CBoardingOptions),
%   member(MToBoard, MBoardingOptions),
%   member(CToBoard, CBoardingOptions),
%   AlreadyBoarded is MInTheBoat + CInTheBoat,
%   NewToBoard is MToBoard + CToBoard,
%   TotalToBoard is NewToBoard + AlreadyBoarded,
%   NewToBoard > 0,
%   TotalToBoard = 2.
%
%
% % generates possible actions given a river state
%
% actions(river(_, Boat, _), A) :-
%   crossing_action_generator(Boat, A).
% actions(river(_, Boat, _), A) :-
%   unboarding_action_generator(Boat, A).
% actions(River, A) :-
%   boarding_action_generator(River, A).
%
% % group(M, C).
%
% with(group(M1, C1), group(M2, C2), group(M3, C3)) :-
%   M3 is M1 + M2,
%   C3 is C1 + C2.
%
% without(group(M1, C1), group(M2, C2), group(M3, C3)) :-
%   M3 is M1 - M2,
%   C3 is C1 - C2.
%
%
% % BOARD ACTIONS
%
%   % board when the boat is at the left bank
%
%   execute(
%       boarding(BoardingGroup),
%       river(
%         bank(LeftGroup),
%         boat(BoatGroup, left),
%         bank(RightGroup)
%       ),
%       river(
%         bank(NewLeftGroup),
%         boat(NewBoatGroup, left),
%         bank(RightGroup)
%       )
%     ) :-
%       without(LeftGroup, BoardingGroup, NewLeftGroup),
%       with(BoatGroup, BoardingGroup, NewBoatGroup).
%
%   % board when the boat is at the right bank
%
%   execute(
%       boarding(BoardingGroup),
%       river(
%         bank(LeftGroup),
%         boat(BoatGroup, right),
%         bank(RightGroup)
%       ),
%       river(
%         bank(LeftGroup),
%         boat(NewBoatGroup, right),
%         bank(NewRightGroup)
%       )
%     ) :-
%       without(RightGroup, BoardingGroup, NewRightGroup),
%       with(BoatGroup, BoardingGroup, NewBoatGroup).
%
% % UNBOARD ACTIONS
%
%     % board when the boat is at the left bank
%
%     execute(
%         unboarding(UnboardingGroup),
%         river(
%           bank(LeftGroup),
%           boat(BoatGroup, left),
%           bank(RightGroup)
%         ),
%         river(
%           bank(NewLeftGroup),
%           boat(NewBoatGroup, left),
%           bank(RightGroup)
%         )
%       ) :-
%         with(LeftGroup, UnboardingGroup, NewLeftGroup),
%         without(BoatGroup, UnboardingGroup, NewBoatGroup).
%
%     % board when the boat is at the right bank
%
%     execute(
%         unboarding(BoardingGroup),
%         river(
%           bank(LeftGroup),
%           boat(BoatGroup, right),
%           bank(RightGroup)
%         ),
%         river(
%           bank(LeftGroup),
%           boat(NewBoatGroup, right),
%           bank(NewRightGroup)
%         )
%       ) :-
%         with(BoardingGroup, RightGroup, NewRightGroup),
%         without(BoatGroup, BoardingGroup, NewBoatGroup).
%
% % RIVER CROSSING ACTIONS
%
%   % since we are matching the boat group on [H|T],
%   % empty groups are not allowed
%
%   % crossing left -> right
%
%   execute(
%     river_crossing(),
%     river(
%       bank(LeftGroup),
%       boat(BoatGroup, left),
%       bank(RightGroup)
%     ),
%     river(
%       bank(LeftGroup),
%       boat(BoatGroup, right),
%       bank(RightGroup)
%     )
%   ).
%
%   % crossing right -> left
%
%   execute(
%     river_crossing(),
%     river(
%       bank(LeftGroup),
%       boat(BoatGroup, right),
%       bank(RightGroup)
%     ),
%     river(
%       bank(LeftGroup),
%       boat(BoatGroup, left),
%       bank(RightGroup)
%     )
%   ).
%
% % generates available actions and executes them
%
% try_action(
%   CurrentState, Action, NewState
% ) :-
%   actions(CurrentState, Action),
%   execute(Action, CurrentState, NewState).
%
% % validate state
%
% valid_group(group(M, _)) :- M = 0.
% valid_group(group(M, C)) :-
%   M > 0,
%   M >= C.
%
% validate_state(
%   river(
%     bank(group(LM, LC)),
%     boat(group(BM, BC), _),
%     bank(group(RM, RC))
%   )
% ) :-
%   % the boat only seats two
%   BoatOccupancy is BM + BC,
%   BoatOccupancy =< 2,
%   % nowhere can there be more cannibals than missionaries
%   valid_group(group(LM, LC)),
%   valid_group(group(BM, BC)),
%   valid_group(group(RM, RC)).
%
% no_loop(CurrentState, Trace) :- not(member(CurrentState, Trace)).
%
% % water jugs

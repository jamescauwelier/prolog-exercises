listlength([],0).

listlength([_|Tail],Count):-
	listlength(Tail,PartialCount),
	Count is PartialCount + 1 .

 % sum of numbers in a list

sumOfNumbers([], 0).

sumOfNumbers([H|T], Sum) :-
  sumOfNumbers(T, TailSum),
  Sum is TailSum + H.

% average

averageOfNumbers([], (0, 0, 0)).

averageOfNumbers([H|T], (Sum, Count, Average)) :-
  averageOfNumbers(T, (TSum, TCount, _)),
  Sum is TSum + H,
  Count is TCount + 1,
  Average is Sum / Count.

% count disks

countdisk([], 0).

countdisk(['w'|T], Count) :-
  countdisk(T, TCount),
  Count is TCount + 1.

countdisk(['b'|T], Count) :-
  countdisk(T, TCount),
  Count is TCount + 1.

countdisk(['n'|T], Count) :-
  countdisk(T, Count).

% LOA game

roundcount([], 0).

roundcount([_|[]], 1).

roundcount([_, _ |T], GameRounds) :-
  roundcount(T, TGameRounds),
  GameRounds is TGameRounds + 1.

% splitMoves

splitMoves([], [], []).

splitMoves([BlackMove], [BlackMove], []).

splitMoves([BlackMove, WhiteMove | T], [BlackMove|TBlackMoves], [WhiteMove|TWhiteMoves]) :-
  splitMoves(T, TBlackMoves, TWhiteMoves).

% mergeMoves ACTUALLY YOU CAN USE THE SPLIT!!!

mergeMoves([], [], []).

mergeMoves([BlackMove], [], [BlackMove]).

mergeMoves([BlackMove|BlackTail], [WhiteMove|WhiteTail], [BlackMove, WhiteMove | TMerged]) :-
  mergeMoves(BlackTail, WhiteTail, TMerged).

listlength([],0).

listlength([_|Tail],Count):-
	listlength(Tail,PartialCount),
	Count is PartialCount + 1 .

sumOfNumbers([], 0).

sumOfNumbers([H|T], Sum) :-
  sumOfNumbers(T, TailSum),
  Sum is TailSum + H.

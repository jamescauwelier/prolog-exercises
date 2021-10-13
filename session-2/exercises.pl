/*
  Exercise 1
*/

split_it(Word, FirstLetter, RestOfWord) :-
  string_length(Word, WordLength),
  RestOfWordLength is WordLength - 1,
  sub_string(Word, 0, 1, _, FirstLetter),
  sub_string(Word, 1, RestOfWordLength, _, RestOfWord).

left_passes_paper("") :-
  write('[finished]').

left_passes_paper(Word) :-
  split_it(Word, FirstLetter, RestOfWord),
  left_passes_paper(RestOfWord),
  write(FirstLetter).

/*
  Exercise 2
*/

direct_road(brugge, ghent).
direct_road(ghent, antwerp).
direct_road(ghent, brussels).
direct_road(antwerp, brussels).
direct_road(hasselt, leuven).
direct_road(brussels, leuven).
direct_road(mons, brussels).
direct_road(mons, namur).
direct_road(namur, liege).
direct_road(bastogne, liege).

reach(From, From) :- true.

reach(From, To) :- direct_road(From, To).

reach(From, To) :-
  direct_road(From, Other),
  reach(Other, To).

/*
  Exercise 3
*/

all_even(Number) :-
  Number < 10,
  R is mod(Number, 2),
  R = 0.

all_even(Number) :-
  Number >= 10,
  Remainder is mod(Number, 10),
  % mod(Remainder, 2) is 0,
  T is mod(Remainder, 2),
  T = 0,
  Quotient is ((Number - Remainder) / 10),
  all_even(Quotient).

/*
  Exercise 4
*/

split_number(N, Last, Rest) :-
  Last is mod(N, 10),
  Rest is ((N - Last) / 10).

even_single_digit(N) :-
  N < 10,
  R is mod(N, 2),
  R = 0.

count_even(N,C) :-
  N < 10,
  (
    even_single_digit(N),
    C is 1
    ;
    C is 0
  ).

count_even(N,C) :-
  N > 9, /* always delineate!!!! */
  split_number(N, CurrentDigit, OtherDigits),
  count_even(OtherDigits, OtherDigitsCount),
  (
    even_single_digit(CurrentDigit),
    C is 1 + OtherDigitsCount
    ;
    C is OtherDigitsCount
  ).

/*
  Exercise 6: Fibonacci numbers
*/

fib(N, F) :-
  (N = 1 ; N = 2),
  F is 1.

fib(N, F) :-
  N1 is N - 1,
  N2 is N - 2,
  fib(N1, F1),
  fib(N2, F2),
  F is F1 + F2.

/*
  Exercise 7: double digit
*/

containsdigit(N, D) :-
  N < 10,
  N = D.

% containsdigit(_, D) :-
  % D > 9, false.

containsdigit(N, D) :-
  D < 10,
  N > 9,
  split_number(N, LastDigit, OtherDigits),
  (
    LastDigit = D
    ;
    containsdigit(OtherDigits, D)
  ).

doubledigit(N) :-
  N < 10, false.

doubledigit(N) :-
  N > 9,
  split_number(N, Last, Rest),
  (
    containsdigit(Rest, Last)
    ;
    doubledigit(Rest)
  ).

doublenextdigits(N) :-
  N > 9,
  split_number(N, N1, Rest),
  split_number(Rest, N2, _),
  (
    N1 = N2
    ;
    doublenextdigits(Rest)
  ).

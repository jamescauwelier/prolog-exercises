%
% solve(Sol) :-
%   generate(Sol),
%   test(Sol),
%   write(Sol), nl.
%
% generate([]).
% generate([H|T]) :-
%   member(H, [1, 2, 3, 4, 5, 6, 7, 8, 9]),
%   generate(T).

% extract row / column data

% extract_row_1(Sol, extraction, Numbers).

% extract_row_1(Sol, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

% extract_row(Sol, RowNumber, Data).
% extract_row(Sol, RowNumber, Data) :-
%   StartIndex is (RowNumber * 9),
%   StopIndex is StartIndex + 9,
%   extract_data(Sol, StartIndex, Size, Result).
%
% extract_data(Sol, StartIndex, Size, Result)

% skip first x number of elements

skip_first(Sol, 0, Sol).
skip_first([_|T], Length, Result) :-
  NextLength is Length - 1,
  skip_first(T, NextLength, Result).

% extract first x number of elements

extract_first(_, 0, Acc, Acc).
extract_first([H1|T1], Length, Acc, Result) :-
  NextAcc = [H1|Acc],
  NextLength is Length - 1,
  extract_first(T1, NextLength, NextAcc, Result).

 % From a list and indices list, how to get the values?

extract_one_index([], 0, _) :- false.
extract_one_index([H|_], 0, H).
extract_one_index([_|T], Index, IndexValue) :-
  NextIndex is Index - 1,
  extract_one_index(T, NextIndex, IndexValue).

extract_all_indices(_, [], []).
extract_all_indices(Input, [Index|OtherIndices], [Value|OtherValues]) :-
  extract_one_index(Input, Index, Value),
  extract_all_indices(Input, OtherIndices, OtherValues).

% Extract all different columns and rows

represent_rows_and_columns(
    Sol,
    [
      Row1, Row2, Row3, Row4, Row5, Row6, Row7, Row8, Row9,
      Col1, Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9,
      Block1, Block2, Block3, Block4, Block5, Block6, Block7, Block8, Block9
    ]
  ) :-
    extract_all_indices(Sol, [], Row1),
    extract_all_indices(Sol, [], Row2),
    extract_all_indices(Sol, [], Row3),
    extract_all_indices(Sol, [], Row4),
    extract_all_indices(Sol, [], Row5),
    extract_all_indices(Sol, [], Row6),
    extract_all_indices(Sol, [], Row7),
    extract_all_indices(Sol, [], Row8),
    extract_all_indices(Sol, [], Row9),

    extract_all_indices(Sol, [], Col1),
    extract_all_indices(Sol, [], Col2),
    extract_all_indices(Sol, [], Col3),
    extract_all_indices(Sol, [], Col4),
    extract_all_indices(Sol, [], Col5),
    extract_all_indices(Sol, [], Col6),
    extract_all_indices(Sol, [], Col7),
    extract_all_indices(Sol, [], Col8),
    extract_all_indices(Sol, [], Col9),

    extract_all_indices(Sol, [], Block1),
    extract_all_indices(Sol, [], Block2),
    extract_all_indices(Sol, [], Block3),
    extract_all_indices(Sol, [], Block4),
    extract_all_indices(Sol, [], Block5),
    extract_all_indices(Sol, [], Block6),
    extract_all_indices(Sol, [], Block7),
    extract_all_indices(Sol, [], Block8),
    extract_all_indices(Sol, [], Block9).

% Test that one list of numbers is unique

is_unique(L) :- is_unique_acc(L, []).
is_unique_acc([], _).
is_unique_acc([H|_], Previous) :-
  member(H, Previous),
  not(var(H)),
  !,fail.
is_unique_acc([H|T], Previous) :-
  var(H),
  is_unique_acc(T, Previous).
is_unique_acc([H|T], Previous) :-
  not(var(H)),
  is_unique_acc(T, [H|Previous]).

% Testing that all lists of numbers are unique

test_all_unique([]).
test_all_unique([H|T]) :-
  is_unique(H),
  test_all_unique(T).
test_all_unique([H|_]) :-
  not(is_unique(H)),!,fail.

% Test whether all elements in a list are unique (happen only once)

test(Sol) :-
  represent_rows_and_columns(Sol, Representation),
  test_all_unique(Representation).

% Incremental solution

solve(Sol) :-
  Size is 9,
  N is Size**2,
  stepwise(1, N, Sol),
  write(Sol), nl.

stepwise(Pos, N, _) :-
  Pos > N, !.
stepwise(Pos, N, Sol) :-
  % generate a value from 1 to 9
  member(Val, [1,2,3,4,5,6,7,8,9]),
  % Index is Pos - 1,
  % extract_one_index(Sol, Pos, Val)

  % assign it to the element as Pos in Sol
  nth_element(Pos, Sol, Val),
  test_stepwise(Pos, Sol),
  Next is Pos + 1,
  stepwise(Next, N, Sol).

test_stepwise(Pos, Sol) :-
  % first we need to know which column, row and cube this is
  get_row_values(Sol, Pos, RowValues),
  get_column_values(Sol, Pos, ColumnValues),
  get_block_values(Sol, Pos, BlockValues),
  test_all_unique([RowValues, ColumnValues, BlockValues]).

get_row_index(Pos, Index).
get_column_index(Pos, Index).
get_block_index(Pos, Index).

get_row_values(Sol, Pos, RowValues) :-

% one approach is to look at the different groups and see where the index is a member

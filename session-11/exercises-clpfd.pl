:- use_module(library(clpfd)).

% FDCLP
% [exercises-clpfd].

% CRIMINAL

crackTheSafe(All) :-
        All = [D1, D2, D3, D4, D5, D6, D7, D8, D9],
        domain(All, 1, 9),
        all_different(All),
        D1 #\= 1,
        D2 #\= 2,
        D3 #\= 3,
        D4 #\= 4,
        D5 #\= 5,
        D6 #\= 6,
        D7 #\= 7,
        D8 #\= 8,
        D9 #\= 9,
        D7 * D7 #= (D4 - D6) * (D4 - D6),
        D1 * D2 * D3 #= D8 + D9,
        D2 + D3 + D6 #< D8,
        D9 #< D8,
        labeling([], All).

% CUPS


cups(Balls) :-
        Balls = [Green, Magenta, Orange, Purple, Red, Yellow],
        Yellow in 1..6,
        domain(Balls, 1, 6),
        all_different(Balls),
        Magenta #= 1,
        Green #= 5,
        Purple #< Orange,
        Red - Magenta #= 1 #\/ Red - Magenta #= -1,
        labeling([], Balls).

% SEATING ARRANGEMENT

% create_guestlist(0, [])
% create_guestlist(GuestCount, GuestList) :-

generate_seat_assignments(0, _, Seating, Seating).
generate_seat_assignments(GuestCount, SeatCount, Seating, Acc) :-
  Guest in 1..SeatCount,
  NextGuestCount #= GuestCount - 1,
  generate_seat_assignments(NextGuestCount, SeatCount, Seating, [Guest|Acc]).

find_assignment(1, [H|_], H).
find_assignment(I, [_|T], A) :-
  I #> 1,
  NextI #= I - 1,
  find_assignment(NextI, T, A).

consider_likes([], _, _).
consider_likes([(Guest1, Guest2)|OtherLikes], TableSize, Seating) :-
  find_assignment(Guest1, Seating, Assignment1),
  find_assignment(Guest2, Seating, Assignment2),
  tbl(Assignment1, TableSize, TableAssignment1),
  tbl(Assignment2, TableSize, TableAssignment2),
  TableAssignment1 #= TableAssignment2,
  consider_likes(OtherLikes, TableSize, Seating).

consider_dislikes([], _, _).
consider_dislikes([(Guest1, Guest2)|OtherDislikes], TableSize, Seating) :-
  find_assignment(Guest1, Seating, Assignment1),
  find_assignment(Guest2, Seating, Assignment2),
  tbl(Assignment1, TableSize, TableAssignment1),
  tbl(Assignment2, TableSize, TableAssignment2),
  TableAssignment1 #\= TableAssignment2,
  consider_dislikes(OtherDislikes, TableSize, Seating).


invert_list(L, IL) :- invert_list(L, IL, []).
invert_list([], IL, IL).
invert_list([H|L], IL, Acc) :-
  NewAcc = [H|Acc],
  invert_list(L, IL, NewAcc).

table_assignment([], _, FullTableAssignment, InvertedFullTableAssignment) :-
  invert_list(InvertedFullTableAssignment, FullTableAssignment).
table_assignment([SeatAssignment|L], TableSize, FullTableAssignment, PartialAssignment) :-
  tbl(SeatAssignment, TableSize, TableAssignment1),
  table_assignment(L, TableSize, FullTableAssignment, [TableAssignment1|PartialAssignment]).

% N = nr. of tables = NTables
% M = TableSize
seats(NTables, TableSize, Likes, Dislikes) :-
  TotalChairs #= NTables * TableSize,
  TotalGuests = TotalChairs,
  % there should be enough chairs and tables

  % this generates the initial list of seating assignments
  generate_seat_assignments(TotalGuests, TotalChairs, Seating, []),
  all_different(Seating),

  % likes should be respected
  consider_likes(Likes, TableSize, Seating),

  % dislikes should be respected
  consider_dislikes(Dislikes, TableSize, Seating),

  labeling([], Seating),
  table_assignment(Seating, TableSize, TableSeating, []),
  print(TableSeating),nl.

tbl(GuestMN, TableSize, GuestTable) :-
  GuestMN mod TableSize #> 0,
  GuestTable #= 1 + GuestMN // TableSize.

tbl(GuestMN, TableSize, GuestTable) :-
  GuestMN mod TableSize #= 0,
  GuestTable #= GuestMN // TableSize.

% add_unique(Add, List, List) :- member(Add, List).
% add_unique(Add, List, [Add|List]) :- not(member(Add, List)).

% counts how many unique guests we have in the provided pairs
% count_guests([], C, C).
% count_guests([(G1, G2)|T], C, Acc) :-
%   add_unique(G1, Acc, Acc1),
%   add_unique(G2, Acc1, Acc2),
%   count_guests(T, C, Acc2).

% consider_likes([], TableSize).
% consider_likes([(Guest1, Guest2)|T], TableSize, TableCount) :-
%   domain([Guest1, Guest2], 1, TableSize*TableCount),
%   tbl(Guest1, TableSize, Table1),
%   tbl(Guest2, TableSize, Table2),
%   Table1 #= Table2,
%   consider_likes(T).
%
% consider_dislikes([], TableSize).
% consider_dislikes([(Guest1, Guest2)|T], TableSize, TableCount) :-
%   domain([Guest1, Guest2], 1, TableSize*TableCount),
%   tbl(Guest1, TableSize, Table1),
%   tbl(Guest2, TableSize, Table2),
%   Table1 #\= Table2,
%   consider_dislikes(T).


% Formulate a query to retrieve ISBN numbers.
isbn_number(X) :-
  book(X, _, _).

% Formulate a query to retrieve the names of books that are hated by their author.
books_hated_by_author(Name) :-
  hates(Person, Isbn),
  author(Person, Isbn),
  book(Isbn, Name, _).

% Formulate a query to retrieve the names of the books together with their author.
% Make Prolog print for each result a line like this: the book booktitle is written by author name
write_book_authors :-
  book(Isbn, BookName, _),
  author(AuthorName, Isbn),
  write('the book '),
  write(BookName),
  write(' is written by author '),
  write(AuthorName).

% Write a predicate proud_author/1 which succeeds for all people that own at least one of the books they have written.
% Q --> Should it return only 1 solution?
proud_author(Author) :-
  author(Author, Isbn),
  owns(Author, Isbn).

% Create a knowledge base which translates your current (book) KB to your native language.
% Or other language than English. That is, in Irish, for example, 'book' is 'leabhar'
% and your task is to automate the translation of your current KB to ... eg., Irish.
% You should not manually rewrite every fact with the different name! You should
% also not translate the actual book titles etc., instead you should be able to
% query your KB in your native language.

boek(Isbn, Title, Pages) :- book(Isbn, Title, Pages).
persoon(Name) :- person(Name).
auteur(Name, Isbn) :- author(Name, Isbn).
haat(Name, Isbn) :- hates(Name, Isbn).
bezit(Name, Isbn) :- owns(Name, Isbn).

/*
How would you represent knowledge of libraries having copies of certain books?
Try to think of multiple representations, discuss pros and cons. Implement the
best representation and test it on some queries.
*/

/*
  Option 1: Add a column with a number of copies.  This keeps track of how many versions there are,
  which requires counting how many have borrowed, but not returned the book.
  Downside is that we don't know who borrowed which version which presents challenges
  for protecting the state in which books are returned.
  Note: I don't know how to count atm.

  Option 2: Have another unique identifier for a version of a book which allows better tracking
 */

book_copy(1, 1).
book_copy(1, 2).
book_copy(23, 3).
book_copy(23, 4).
book_copy(23, 5).
book_copy(24, 6).

borrow('James', 1, 1).
borrow('George', 1, 2).
borrow('James', 23, 3).
borrow('John', 23, 3).
borrow('George', 23, 4).
borrow('Will', 23, 5).

returned('James', 23, 3).
returned('Will', 23, 5).

/*
  A book is available:
  - if it has not been borrowed
  - if it was returned by everyone that borrowed it
 */

 copy_not_available(Isbn, Copynumber) :-
   book_copy(Isbn, Copynumber),
   borrow(Person, Isbn, Copynumber),
   not(returned(Person, Isbn, Copynumber)).

 copy_available(Isbn, Version) :-
   book_copy(Isbn, Version),
   not(borrow(_, Isbn, Version)).

 % copy_available(Isbn, Version) :-
 %   book_copy(Isbn, Version),
 %   borrow(P, Isbn, Version),
 %   returned(P, Isbn, Version).



% copy_available(Isbn, Copynumber) :-
  % book_copy(Isbn, Copynumber),
  % not(borrow(_, Isbn, Copynumber));
  % {
  %   borrow(P, Isbn, Copynumber),
  %   turned_in(P, Isbn, Copynumber)
  % }.

% copy_available(Isbn, BookNumber, CopyNumber) :-

% With what you know so far, is it possible to write a predicate that returns the
% number of books in the knowledge base?
% TODO

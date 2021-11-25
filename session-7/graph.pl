arc(From,To,Graph) :-
	member(From/To,Graph).

% connected(X,X,_).
% connected(X,Y,Graph) :-
% 	arc(Z,Y,Graph),
% 	connected(X,Z,Graph).

find_path_2(X,Y,Path,Graph) :-
        find_path_acc_2(X,Y,Path,[Y],Graph).

find_path_acc_2(X,X,Path,Path,_).
find_path_acc_2(X,Y,Path,Acc,G) :-
	arc(Z,Y,G),
        not(member(Z,Acc)), % <------ only difference
	find_path_acc_2(X,Z,Path,[Z|Acc],G).

connected(X,Y,Graph):-
        find_path_2(X,Y,_,Graph).

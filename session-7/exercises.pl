% Graphs[]
% [a/c,c/d,c/e,b/d,d/e]

p(Graph,Node) :- member(Parent/Node,Graph), write(Parent), nl, fail.
p(_Graph,_Node) :- write('end').

parents(Graph, Parents) :- findall(Parent, member(Parent/_,Graph), Parents).

all_paths(X,Y,Graph,AllPaths) :-
  findall(Path, find_path_2(X, Y, Path, Graph), AllPaths).


find_shortest([], R, _, R).

find_shortest([Path|T], R, LengthAcc, _) :-
  listlength(Path, PathLength),
  PathLength < LengthAcc,
  find_shortest(T, R, PathLength, Path).

find_shortest([Path|T], R, LengthAcc, PathAcc) :-
  listlength(Path, PathLength),
  PathLength >= LengthAcc,
  find_shortest(T, R, LengthAcc, PathAcc).


% find_shortest([], [], _, _).

shortest_path(X,Y,Graph,Shortest) :-
  findall(Path, find_path_2(X, Y, Path, Graph), [FirstPath|OtherPaths]),
  listlength(FirstPath, FirstLength),
  find_shortest(OtherPaths, Shortest, FirstLength, FirstPath).

% REACTIONS

% reactions :- [
%   reacts(vinegar,salt,25),
%   reacts(salt,water,3),
%   reacts('brown soap',water,10),
%   reacts('pili pili', milk,7),
%   reacts(tonic,bailey,8)
%   ].

ingredient_reaction(Ingredients, Reactions, Score) :-
  member(I1, Ingredients),
  member(I2, Ingredients),
  member(reacts(I1, I2, Score), Reactions).

reaction_ingredient_score(reacts(I1, I2, Score), Ingredients, Score) :-
  member(I1, Ingredients),
  member(I2, Ingredients).

reaction_ingredient_score(_, _, 0).

advice_score(Ingredients, AdviceScore) :-
  reactions = [
    reacts(vinegar,salt,25),
    reacts(salt,water,3),
    reacts('brown soap',water,10),
    reacts('pili pili', milk,7),
    reacts(tonic,bailey,8)
    ],
  findall(Score, ingredient_reaction(Ingredients, reactions, Score), AllReactionIngredientScores),
  sumOfNumbers(AllReactionIngredientScores, AdviceScore).

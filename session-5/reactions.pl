% REACTION SCORES FOR MIXING

reacts(vinegar,salt,25).
reacts(salt,water,3).
reacts('brown soap',water,10).
reacts('pili pili', milk,7).
reacts(tonic,bailey,8).

% ?- advice([vinegar,salt,water]).
% Warning: this mixture causes severe burning wounds, never use this!
% Yes
%
% ?- advice([jam, salt, pepper, water, 'red onions', 'brown soap']).
% Warning: this mixture could result in minor burning wounds!
% Yes

% What is the total score for a list of ingredients?

single_reaction_score([I1, I2], Score) :-
	reacts(I1, I2, Score).

single_reaction_score([I1, I2], Score) :-
	reacts(I2, I1, Score).

single_reaction_score([I1, I2], 0) :-
	not(reacts(I1, I2, Score)),
	not(reacts(I2, I1, Score)).

% Get the combinations in a mixture:
% reaction_pairs([I1, I2, I3], [[I1, I2],[I1, I3], [I2, I3]])

reaction_pairs([], []).
reaction_pairs([_], []).
reaction_pairs([H1|[H2|T]], [[H1, H2]|Pairs]) :-
	reaction_pairs([H1|T], H1Pairs),
	reaction_pairs([H2|T], H2Pairs),
	append(H1Pairs, H2Pairs, Pairs).

% combined_reaction_score([])

combined_score([], 0).
combined_score([Pair|T], Score) :-
	single_reaction_score(Pair, SScore),
	combined_score(T, TScore),
	Score is TScore + SScore.

% Advice

print_advice(Score) :-
	Score =< 5,
	print("No irritation").
print_advice(Score) :-
	Score >= 5,
	Score =< 12,
	print("Minor irritation").
print_advice(Score) :-
	Score >= 13,
	Score =< 20,
	print("Minor burn wounds").
print_advice(Score) :-
	Score >= 21,
	Score =< 30,
	print("Major burn wounds").
print_advice(Score) :-
	Score > 30,
	print("Warning: you may die from this mixture").

advice(Ingredients) :-
	reaction_pairs(Ingredients, Pairs),
	combined_score(Pairs, Score),
	print_advice(Score).

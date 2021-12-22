%This exercise is about loans. You are given
%  P, the amount of money lent,
%  T, the number of periods in the loan,
%  I, the interest rate on the loan,
%  MP, the amount we pay back each period.
%
%We define the balance after a number of periods as follows. After 0 periods the 
%balance is simply P. After T periods (T>0) the balance is B1*(1+I)-MP, where B1 
%stands for the balance after T-1 periods (so this is a recursive definition).
%
%First, write a predicate to calculate the balance after T periods using pure 
%prolog. Then write this predicate using CLP. Can you calculate the amount of 
%your loan (P) given the other arguments (T,I,MP and the balance B) with these 
%predicates? Are there any arguments you can't calculate with the CLP version?

:- use_module(library(clpr)).

% ?- balance(loan(1000, 4, 0.04, 250), B).

loan(P, 0, _, _, B) :- B = P.
loan(P, T, I, MP, B) :-
        T > 0,
        NextT is T - 1,
        loan(P, NextT, I, MP, NextB),
        B is NextB * (1+I) - MP.

% ?- balance_clp(loan(1000, 4, 0.04, 250), B).

loan_clp(P, T, _, _, B) :- 
        { 
            T = 0, 
            B = P 
        }.
loan_clp(P, T, I, MP, B) :-
        { 
            T > 0,
            NextT = T - 1,
            B = B1*(1+I)-MP
            },
        loan_clp(P, NextT, I, MP, B1).

% FDCLP
% use_module(library(clpfd)).



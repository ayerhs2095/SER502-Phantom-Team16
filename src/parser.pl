:- table expr/3, expr1/3, term/3, bool_expr/3.
:- use_rendering(svgtree).

% Author: Jean
% Purpose: DCG for boolean expression and arithmetic expression
% Version: 1
% Date: Nov 1, 2024

bool_expr(==(X,Y)) --> expr(X),['=='],expr(Y).
bool_expr(<=(X,Y)) --> expr(X),['<='],expr(Y).
bool_expr(<(X,Y)) --> expr(X),['<'],expr(Y).
bool_expr(>=(X,Y)) --> expr(X),['>='],expr(Y).
bool_expr(>(X,Y)) --> expr(X),['>'],expr(Y).
bool_expr(not(X)) --> [not],bool_expr(X).
bool_expr(and(X,Y)) --> bool_expr(X),[and],bool_expr(Y).
bool_expr(or(X,Y)) --> bool_expr(X), [or],bool_expr(Y).
bool_expr(true) --> [true].
bool_expr(false) --> [false].


expr('='(X,Y)) --> id(X),[=],expr1(Y).
expr(X) --> expr1(X).
expr1(+(X,Y)) --> expr1(X), [+], term(Y).
expr1(-(X,Y)) --> expr1(X), [-], term(Y).
expr1(X) --> term(X).
term((X,Y))--> term(X), [], num(Y).
term(/(X,Y))--> term(X), [/], num(Y).
term(X) --> ['('],expr(X),[')'].
term(X) --> num(X).
term(X) --> id(X).
num(X) --> [X], {number(X)}.
id(X) --> [X], {atom(X)}.

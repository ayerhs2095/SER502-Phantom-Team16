:- table expr/3, expr1/3, term/3, bool_expr/3.
:- use_rendering(svgtree).

program(program(X)) --> ['{'],command(X),['}'].

%Author:Shreya
%Purpose:DCG for conditional expression
%Version:1
%Date:Nov 1,2024

command((X,Y)) --> command(X),command(Y).
command(=(X,Y)) --> id(X), [=], expr(Y),[;].
command(=(X,Y)) --> [const], id(X), [=], expr(Y),[;].

% if Conditional statement 
command(if(X,Y,Z)) --> 
    [if], ['('], bool_expr(X), [')'], ['{'], command(Y), ['}'],[else], ['{'], command(Z), ['}'].
command(if(X,Y,Z)) -->
    bool_expr(X),[?],command(Y),[:],command(Z).

%Author:Reuben
%Purpose:DCG for iteration (while loop, for loop, do while loop)
%Version:1
%Date:Nov 1,2024

% Iteration Rules
% While Loop 
command(while(X,Y)) --> 
    [while], ['('], bool_expr(X), [')'], ['{'], command(Y), ['}'].

% For Loop
command(for(start(=(V,W)),condition(X),update(Y,U),body(Z))) -->
    [for],['('], id(V), [=], expr(W), [;],
    bool_expr(X), [;],
    id(Y), [=], expr(U),[')'],
    ['{'],command(Z),['}'].

% Do-While Loop
command(do_while(body(Y), condition(X))) -->
    [do], ['{'], command(Y), ['}'],
    [while], ['('], bool_expr(X), [')'], [';'].

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

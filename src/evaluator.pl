:- table expr_eval/4.

% RUN TIME ENVIRONMENT

% Environment look up -> lookup(Env,Id,Value).
lookup([[Id,Value]|_],Id,Value).
lookup([[H,_]|T],Id,Value):- H\=Id, lookup(T,Id,Value).
lookup([],_,_):-write('Runtime Error').
    
% Environment update -> update(Env,Id,Value,NewEnv).
update([],1,-1,[]).
update([],Id,Value,[[Id,Value]]):- Id\=1.
update([[X,V]|T],Id,Value,[[X,V]|R]):-
    X\=Id, update(T,Id,Value,R).
update([[Id,_]|T],Id,Value,[[Id,Value]|R])
	:- update(T,1,-1,R).

% evaluate boolean expression
boolean_expr_eval(Expr1==Expr2,Env,NewEnv2,true):-
    expr_eval(Env,Expr1,Value1,NewEnv1),
    expr_eval(NewEnv1,Expr2,Value2,NewEnv2),
    Value1=Value2.
boolean_expr_eval(Expr1==Expr2,Env,NewEnv2,false):-
    expr_eval(Env,Expr1,Value1,NewEnv1),
    expr_eval(NewEnv1,Expr2,Value2,NewEnv2),
    Value1\=Value2.

boolean_expr_eval(<=(Expr1,Expr2),Env,NewEnv2,true):-
    expr_eval(Env,Expr1,Value1,NewEnv1),
    expr_eval(NewEnv1,Expr2,Value2,NewEnv2),
    Value1=<Value2.
boolean_expr_eval(<=(Expr1,Expr2),Env,NewEnv2,false):-
    expr_eval(Env,Expr1,Value1,NewEnv1),
    expr_eval(NewEnv1,Expr2,Value2,NewEnv2),
    Value1>Value2.

boolean_expr_eval(Expr1<Expr2,Env,NewEnv2,true):-
    expr_eval(Env,Expr1,Value1,NewEnv1),
    expr_eval(NewEnv1,Expr2,Value2,NewEnv2),
    Value1<Value2.
boolean_expr_eval(Expr1<Expr2,Env,NewEnv2,false):-
    expr_eval(Env,Expr1,Value1,NewEnv1),
    expr_eval(NewEnv1,Expr2,Value2,NewEnv2),
    Value1>=Value2.

boolean_expr_eval(Expr1>Expr2,Env,NewEnv2,true):-
    expr_eval(Env,Expr1,Value1,NewEnv1),
    expr_eval(NewEnv1,Expr2,Value2,NewEnv2),
    Value1>Value2.
boolean_expr_eval(Expr1>Expr2,Env,NewEnv2,false):-
    expr_eval(Env,Expr1,Value1,NewEnv1),
    expr_eval(NewEnv1,Expr2,Value2,NewEnv2),
    Value1=<Value2.

boolean_expr_eval(Expr1>=Expr2,Env,NewEnv2,true):-
    expr_eval(Env,Expr1,Value1,NewEnv1),
    expr_eval(NewEnv1,Expr2,Value2,NewEnv2),
    Value1>=Value2.
boolean_expr_eval(Expr1>=Expr2,Env,NewEnv2,false):-
    expr_eval(Env,Expr1,Value1,NewEnv1),
    expr_eval(NewEnv1,Expr2,Value2,NewEnv2),
    Value1<Value2.

boolean_expr_eval(not(Expr),Env,NewEnv,false):-
    boolean_expr_eval(Expr, Env, NewEnv,true).
boolean_expr_eval(not(Expr),Env,NewEnv,true):-
    boolean_expr_eval(Expr, Env, NewEnv,false).

boolean_expr_eval(and(Expr1,Expr2),Env,NewEnv2,true):-
    boolean_expr_eval(Expr1, Env, NewEnv1,true),
    boolean_expr_eval(Expr2, NewEnv1, NewEnv2, true).
boolean_expr_eval(and(Expr1,Expr2),Env,NewEnv2,false):-
    boolean_expr_eval(Expr1, Env, NewEnv1,true),
    boolean_expr_eval(Expr2, NewEnv1, NewEnv2, false).
boolean_expr_eval(and(Expr1,Expr2),Env,NewEnv2,false):-
    boolean_expr_eval(Expr1, Env, NewEnv1,false),
    boolean_expr_eval(Expr2, NewEnv1, NewEnv2, true).
boolean_expr_eval(and(Expr1,Expr2),Env,NewEnv2,false):-
    boolean_expr_eval(Expr1, Env, NewEnv1,false),
    boolean_expr_eval(Expr2, NewEnv1, NewEnv2, false).

boolean_expr_eval(or(Expr1,Expr2),Env,NewEnv2,true):-
    boolean_expr_eval(Expr1, Env, NewEnv1,true),
    boolean_expr_eval(Expr2, NewEnv1, NewEnv2, true).
boolean_expr_eval(or(Expr1,Expr2),Env,NewEnv2,true):-
    boolean_expr_eval(Expr1, Env, NewEnv1,true),
    boolean_expr_eval(Expr2, NewEnv1, NewEnv2, false).
boolean_expr_eval(or(Expr1,Expr2),Env,NewEnv2,true):-
    boolean_expr_eval(Expr1, Env, NewEnv1,false),
    boolean_expr_eval(Expr2, NewEnv1, NewEnv2, true).
boolean_expr_eval(or(Expr1,Expr2),Env,NewEnv2,false):-
    boolean_expr_eval(Expr1, Env, NewEnv1,false),
    boolean_expr_eval(Expr2, NewEnv1, NewEnv2, false).

% evaluate expression
expr_eval(Env,Val,Value,Env):-
    val_eval(Env,Val,Value).
expr_eval(Env,X+Y,Value,NewEnv2):-
    expr_eval(Env,X,X_Value,NewEnv1),expr_eval(NewEnv1,Y,Y_Value,NewEnv2),
    Value is X_Value+Y_Value.
expr_eval(Env,X-Y,Value,NewEnv2):-
    expr_eval(Env,X,X_Value,NewEnv1),expr_eval(NewEnv1,Y,Y_Value,NewEnv2),
    Value is X_Value-Y_Value.
expr_eval(Env,X*Y,Value,NewEnv2):-
    expr_eval(Env,X,X_Value,NewEnv1),expr_eval(NewEnv1,Y,Y_Value,NewEnv2),
    Value is X_Value*Y_Value.
expr_eval(Env,X/Y,Value,NewEnv2):-
    expr_eval(Env,X,X_Value,NewEnv1),expr_eval(NewEnv1,Y,Y_Value,NewEnv2),
    Value is X_Value/Y_Value.
expr_eval(Env,(Expr),Value,NewEnv):-
    expr_eval(Env,Expr,Value,NewEnv).
expr_eval(Env,X=Expr,Value,NewEnv2):-
    expr_eval(Env,Expr,Value,NewEnv1),
    update(NewEnv1,X,Value,NewEnv2).

% evaluate values
val_eval(_,Id,Id):-number(Id).
val_eval(Env,Id,Value):- 
    atom(Id), lookup(Env,Id,Value).

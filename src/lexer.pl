% Author: Deepanjay Nandal
% Purpose: Transforms input text into structured tokens for parsing
% Version: 1
% Date: 1st November 2024

lexer(Input, Tokens) :-
    string_chars(Input, Chars),
    tokenize(Chars, [], TokensRev),
    reverse(TokensRev, Tokens).

% Tokenize the character list into tokens
tokenize([], Tokens, Tokens).
tokenize([H|T], TokenAcc, Tokens) :-
    (   char_type(H, space)
    ->  tokenize(T, TokenAcc, Tokens)  % Skip spaces
    ;   handle_token([H|T], NewT, Token)
    ->  tokenize(NewT, [Token|TokenAcc], Tokens)  % Add new Token to the end of list
    ;   tokenize(T, TokenAcc, Tokens)  % Skip character if no token can be formed
    ).

% Handle tokens
handle_token(Input, RestT, Token) :-
    ( multi_char_operator(Input, RestT, Token) ->
        true
    ; single_char_operator(Input, RestT, Token) ->
        true
    ; number_token(Input, RestT, Token) ->
        true
    ; string_token(Input, RestT, Token) ->
        true
    ; identifier_or_keyword_token(Input, RestT, Token) ->
        true
    ; assignment_token(Input, RestT, Token) ->
        true
    ).

% Operators
multi_char_operator(['n', 'o', 't'|T], RestT, 'not') :- next_non_alpha(T, RestT).
multi_char_operator(['a', 'n', 'd'|T], RestT, 'and') :- next_non_alpha(T, RestT).
multi_char_operator(['o', 'r'|T], RestT, 'or') :- next_non_alpha(T, RestT).
multi_char_operator(['=', '=', H|T], RestT, '==') :- next_non_alpha([H|T], RestT).
multi_char_operator(['>', '=', H|T], RestT, '>=') :- next_non_alpha([H|T], RestT).
multi_char_operator(['<', '=', H|T], RestT, '<=') :- next_non_alpha([H|T], RestT).

% Single character operators
single_char_operator([H|T], T, Token) :-
    member(H, ['+', '-', '*', '/', '=', '?', ';', ',', '.', '(', ')', '{', '}']),
    atom_chars(Token, [H]).

% Assignment token
assignment_token([H|T], RestT, Token) :-
    valid_identifier_start(H),
    consume_identifier_chars([H|T], IdChars, RestT1),
    RestT1 = [ '=', ';' | RestT],  % Ensure assignment ends with '=' and requires ';'
    atom_chars(Identifier, IdChars),
    atom_concat(Identifier, ' = ', Temp),
    atom_concat(Temp, ';', Token).

% Numeric token
number_token([H|T], RestT, Number) :-
    char_type(H, digit),
    consume_digits([H|T], Digits, RestT),
    atom_chars(AtomDigits, Digits),
    atom_number(AtomDigits, Number).

% String literals including quotes
string_token(['"'|T], RestT, Token) :-
    string_chars_token(T, Chars, RestT),
    atom_concat('"', Chars, Temp),
    atom_concat(Temp, '"', Token).

% Helper predicate for characters until the closing quote
string_chars_token(['"'|T], '', T).
string_chars_token([H|T], Chars, RestT) :-
    string_chars_token(T, TailChars, RestT),
    atom_concat(H, TailChars, Chars).

% Identifiers or keywords
identifier_or_keyword_token([H|T], RestT, Identifier) :-
    valid_identifier_start(H),
    consume_identifier_chars([H|T], IdChars, RestT),
    atom_chars(Identifier, IdChars).

% Helper predicate for digits
consume_digits([H|T], [H|RestDigits], RestT) :-
    char_type(H, digit),
    consume_digits(T, RestDigits, RestT).
consume_digits(T, [], T).

% Helper predicate for identifiers
consume_identifier_chars([H|T], [H|RestIdChars], RestT) :-
    valid_identifier_char(H),
    consume_identifier_chars(T, RestIdChars, RestT).
consume_identifier_chars(T, [], T).

% Identifier validation
valid_identifier_start(H) :-
    \+ char_type(H, space),
    \+ member(H, ['+', '-', '*', '/', '=', '?', ';', ',', '.', '"', '(', ')', '{', '}']).

valid_identifier_char(H) :-
    char_type(H, alnum); H == '_'.

% Check if the next character is non-alphabetic
next_non_alpha([], []).
next_non_alpha([H|T], [H|T]) :-
    \+ char_type(H, alpha).

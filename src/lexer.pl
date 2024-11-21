% Author: Deepanjay Nandal
% Purpose: Transforms input text into structured tokens for parsing
% Version: 1
% Date: 1st Nov, 2024

lexer(Input, Tokens) :-
    string_chars(Input, Chars),
    process_tokens(Chars, [], RevTokens),
    reverse(RevTokens, Tokens).

process_tokens([], Tokens, Tokens).
process_tokens([H|T], Accum, Tokens) :-
    (   char_type(H, space)
    ->  process_tokens(T, Accum, Tokens)
    ;   identify_token([H|T], Remaining, Token)
    ->  process_tokens(Remaining, [Token|Accum], Tokens)
    ;   process_tokens(T, Accum, Tokens)
    ).

identify_token(Input, Remaining, Token) :-
    (   multi_char_op(Input, Remaining, Token)
    ;   single_char_op(Input, Remaining, Token)
    ;   string_literal(Input, Remaining, Token)
    ;   numeric_token(Input, Remaining, Token)
    ;   keyword_or_id(Input, Remaining, Token)
    ).

multi_char_op(['=', '=', H|T], [H|T], '==').
multi_char_op(['>', '=', H|T], [H|T], '>=').
multi_char_op(['<', '=', H|T], [H|T], '<=').
multi_char_op(['!', '=', H|T], [H|T], '!=').

single_char_op([H|T], T, Token) :-
    member(H, ['+', '-', '*', '/', '=', '?', ':', ';', ',', '.', '(', ')', '{', '}', '<', '>']),
    atom_chars(Token, [H]).

string_literal(['"'|T], Remaining, String) :-
    extract_string_content(T, Chars, Remaining),
    atom_chars(String, ['"'|Chars]).

extract_string_content(['"'|T], ['"'|[]], T).
extract_string_content([H|T], [H|Chars], Remaining) :-
    extract_string_content(T, Chars, Remaining).

numeric_token([H|T], Remaining, Number) :-
    char_type(H, digit),
    collect_digits([H|T], Digits, Remaining),
    atom_chars(Atom, Digits),
    atom_number(Atom, Number).

keyword_or_id([H|T], Remaining, Token) :-
    valid_id_start(H),
    collect_id_chars([H|T], Chars, Remaining),
    atom_chars(Token, Chars).

collect_digits([H|T], [H|Rest], Remaining) :-
    char_type(H, digit),
    collect_digits(T, Rest, Remaining).
collect_digits(T, [], T).

collect_id_chars([H|T], [H|Rest], Remaining) :-
    valid_id_char(H),
    collect_id_chars(T, Rest, Remaining).
collect_id_chars(T, [], T).

valid_id_start(H) :- char_type(H, alpha).
valid_id_char(H) :- char_type(H, alnum) ; H == '_'

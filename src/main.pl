:- include(lexer).
:- include(parser).
:- include(evaluator).

 run(FileLocation):-
   read_file_to_string(FileLocation, Program, []),
   lexer(Program,Tokens),
   program(ParseTree,Tokens,[]),
   program_eval(ParseTree,Environment),
   nl,write('Final Environment: '),
   write(Environment), nl.

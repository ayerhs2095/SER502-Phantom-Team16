:- include(lexer).
:- include(parser).
:- include(evaluator).

 open(FileLocation,read,Program),
   lexer(Program,Tokens),
   program(ParseTree,Tokens),
   program_eval(ParseTree,Environment),
   close(Program),
   write('Final Environment: '),
   write(Environment), nl.

-module(wordle_test).

-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

lowercase1_check_guess_test() ->
  Guess = "stand",
  Word  = "straw",
  Res = wordle:check_guess(Guess, Word),
  ?assertMatch({Guess, [green, green, yellow, grey, grey]}, Res).

duplicate_letter1_check_guess_test() ->
  Guess = "crass",
  Word  = "sales",
  Res = wordle:check_guess(Guess, Word),
  ?assertMatch({Guess, [grey, grey, yellow, yellow, green]}, Res).

-endif.
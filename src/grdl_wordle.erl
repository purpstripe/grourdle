-module(grdl_wordle).
-import(string,[equal/2]).
-export([get_answer/0, check_guess/2]).

%% @doc Check a Wordle guess against a provided word.
%% @returns A tuple containing the Guess and a list of
%% colors based on where the letters appear in the provided Word.

%%checks for exact matches, then checks remaining letters for yellows, default grey
%%3> wordle:check_guess("crate","cheek").
%%    [green,grey,grey,grey,yellow]
%%4> wordle:check_guess("check","cheek").
%%    [green,green,green,grey,green]

get_answer() ->
  "bread".

check_guess(G, W) when is_binary(G) ->
  check_guess(binary_to_list(G), W);

check_guess(G, W) when is_binary(W) ->
  check_guess(G, binary_to_list(W));

check_guess(Guess, Word) ->
  Res = check_for_green(Guess, 1, Word, [grey,grey,grey,grey,grey]),
  New_guess = element(1, Res),
  New_word = element(2, Res),
  New_result = element(3, Res),
  Final_res = check_for_yellow(New_guess, 1, New_word, New_result),
  element(3, Final_res).

%lists:nth(index,list)
check_for_green(Guess, Index, Word, Result) ->
  case Index > length(Word) of
    true -> {Guess, Word, Result};
    false ->
      G_letter = getnth(Index, Guess),
      W_letter = getnth(Index, Word),
      case G_letter =:= W_letter of
        true -> New_result = setnth(Index, Result, green),
          check_for_green(setnth(Index, Guess, "-"), Index, setnth(Index, Word, "_"), New_result);
        false -> check_for_green(Guess, Index + 1, Word, Result)
      end
  end.

check_for_yellow(Guess, Index, Word, Result) ->
  case Index > length(Word) of
    true -> {Guess, Word, Result};
    false ->
      G_letter = getnth(Index, Guess),
      case (lists:member(G_letter, Word) andalso getnth(Index, Result) =:= grey) of
        true ->
          New_result = setnth(Index, Result, yellow),
          W_ind = index_of(G_letter, Word),
          check_for_yellow(setnth(Index, Guess, "-"), Index, setnth(W_ind, Word, "_"), New_result);
        false -> check_for_yellow(Guess, Index + 1, Word, Result)
      end
  end.

%I made these because I'm cringe, dont look at me
setnth(1, [_|Rest], New) -> [New|Rest];
setnth(I, [E|Rest], New) -> [E|setnth(I-1, Rest, New)].

getnth(1, [N|_]) -> N;
getnth(I, [_|Rest]) -> getnth(I-1, Rest).

index_of(Item, List) -> index_of(Item, List, 1).

index_of(_, [], _)  -> not_found;
index_of(Item, [Item|_], Index) -> Index;
index_of(Item, [_|Tl], Index) -> index_of(Item, Tl, Index+1).
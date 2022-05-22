take(Src,N,L) :- findall(E, (nth1(I,Src,E), I =< N), L).

slice(L, From, To, R):-
  length(LFrom, From),
  length([_|LTo], To),
  append(LTo, _, L),
  append(LFrom, R, LTo).

replace([_|T], 0, X, [X|T]):-!.
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).

setPopulation(Pop):-
    retractall(population),
    asserta(population(Pop):-!),
    !.

setGames(L):-
    retractall(listOfGames),
    asserta(listOfGames(L):-!),
    !.
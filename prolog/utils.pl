take(Src,N,L) :- findall(E, (nth1(I,Src,E), I =< N), L).



slice(L, From, To, R):-
  length(LFrom, From),
  length([_|LTo], To),
  append(LTo, _, L),
  append(LFrom, R, LTo).

firstN(L,N,Res):-
    End is (N+1),
    slice(L,0,End,Res),
    !.


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

% Logging
writeStatistics(Gen):-
    write("Gen: "),write(Gen),
    population(Pop),
    fitnesses(Pop,Fs),
    min_list(Fs,Min),
    max_list(Fs,Max),
    average(Fs,Mean),
    write(" Min: "),write(Min),
    write(" Max: "),write(Max),
    write(" Mean: "),write(Mean),
    nl,
    
    !.

fitnesses(Pop,Out):-
    fitnesses(Pop,[],Out),
    !.
fitnesses([],Temp,Temp):-!.
fitnesses([I|Rest],Temp,Out):-
    fitness(I,F),
    append([F],Temp,Temp2),
    fitnesses(Rest,Temp2,Out),
    !.

average(List,Average):- 
    sumlist(List,Sum),
    length(List,Length),
    Length>0, 
    Average is Sum/Length.



% Negative of finess. Used for sorting.
% negFiness(i,o).
negFitness(Individual,F):- %For sorting
    fitness(Individual,Temp),
    F is Temp*(-1),
    !.

% Determines the better and worse from individuals A and B.
% betterAndWorse(i,i,o,o).
betterAndWorse(A,B,Better,Worse):-
    fitness(A,Fa),
    fitness(A,Fb),
    Fa>Fb,
    Better is A,
    Worse is B,
    !.
betterAndWorse(A,B,B,A):-!.

% Sort by fitness in descending order.
% sortByFitness(i,o).
sortByFitness(L,Sorted):-
    population(L),
    map_list_to_pairs(negFitness,L,Pairs),
    keysort(Pairs,Temp),
    pairs_values(Temp, Sorted),
    !.

% Detrmines de fitness of a list of individuals.
% fitnesses(i,o).
fitnesses(Pop,Out):-
    fitnesses(Pop,[],Out),
    !.
fitnesses([],Temp,Temp):-!.
fitnesses([I|Rest],Temp,Out):-
    fitness(I,F),
    append([F],Temp,Temp2),
    fitnesses(Rest,Temp2,Out),
    !.

% Determines if an assignment is valid (nConflicts is 0).
% valid(i).
valid(Assignment):-
    nTeams(N),
    nConflicts(Assignment,N,Out),
    Out=:=0,
    !.

% Determines the set of individuals from population that are valid.
% setOfValid(o).
setOfValid(Res):-
    population(Pop),
    include(valid,Pop,List),
    list_to_set(List,Res),
    !.




% Count the number of occurances in a list.
% count(i,i,o).
count([],_,0).
count([H|T],H,NewCount):-
    count(T,H,OldCount),
    NewCount is OldCount +1,
    !.
count([H|T] , H2,Count):-
 dif(H,H2),
 count(T,H2,Count),
 !.

% Slice a list [From,To).
% slice(i,i,i,o).
slice(L, From, To, R):-
  length(LFrom, From),
  length([_|LTo], To),
  append(LTo, _, L),
  append(LFrom, R, LTo).

% Determines first N elements of a list.
% fitstN(i,i,o).
firstN(L,N,Res):-
    End is (N+1),
    slice(L,0,End,Res),
    !.

% Determines last N elements of a list.
% last(i,i,o).
lastN(L,N,Res):-
    length(L,End),
    ActualEnd is (End+1),
    S is (End-N),
    ActualStart is max(S,0),
    slice(L,ActualStart,ActualEnd,Res),
    !.

% Replaces the element at an index with a new element.
% replace(i,i,i,o).
replace([_|T], 0, X, [X|T]):-!.
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).


% Sets population as Pop in dynamic database.
% setPopulation(i).
setPopulation(Pop):-
    retractall(population),
    asserta(population(Pop):-!),
    !.

% Sets games as L in dynamic database.
% setGames(i).
setGames(L):-
    retractall(listOfGames),
    asserta(listOfGames(L):-!),
    !.

% Writes Parameters
parameters:-
    write("\nShowing parameters"),nl,nl,
    n(N),
    write("Population size: "),write(N),nl,
    nTeams(Nteams),
    write("Number of teams: "),write(Nteams),nl,
    mutationRate(Mr),
    write("Mutation rate: "),write(Mr),nl,
    propElite(P),
    nElite(E),
    write("Elite proportion: "),write(P),write(" ("),write(E),write(")"),nl,
    coldness(C),
    write("Coldness: "),write(C),nl,nl,
    !.

% Writes relevant statistics.
% writeStatistics(i,i,i).
writeStatistics(Gen,Fs,TimeSince):-
    write("Gen: "),write(Gen),
    min_list(Fs,Min),
    max_list(Fs,Max),
    average(Fs,Mean),
    write(" Min: "),format("~2f", [Min]),
    write(" Mean: "),format("~2f", [Mean]),
    write(" Max: "),format("~2f", [Max]),
    write(" Time Since Improvement: "),write(TimeSince),
    nl,  
    !.


% Determines the average of a list.
% average(i,o).
average(List,Average):- 
    sumlist(List,Sum),
    length(List,Length),
    Length>0, 
    Average is Sum/Length.



outputToFile(Filename):-
    setOfValid(List),
    open(Filename, write, File),
    writeList(File, List),
    close(File).

writeList(_File, []) :- !.
writeList(File, [Head|Tail]) :-
    write(File, Head),
    fitness(Head,F),
    write(File,","),write(File,F),
    write(File, '\n'),
    writeList(File, Tail).
fitness(Individual,F):-
    nTeams(N),
    nConflicts(Individual,N,Conf),
    F is Conf*(-1),
    !.

negFitness(Individual,F):- %For sorting
    fitness(Individual,Temp),
    F is Temp*(-1),
    !.


betterAndWorse(A,B,Better,Worse):-
    fitness(A,Fa),
    fitness(A,Fb),
    Fa>Fb,
    Better is A,
    Worse is B,
    !.
betterAndWorse(A,B,B,A):-!.

sortByFitness(L,Sorted):-
    population(L),
    map_list_to_pairs(negFitness,L,Pairs),
    keysort(Pairs,Temp),
    pairs_values(Temp, Sorted),
    !.

valid(Assignment):-
    nTeams(N),
    nConflicts(Assignment,N,Out),
    Out=:=0,
    !.

setOfValid(Res):-
    population(Pop),
    include(valid,Pop,List),
    list_to_set(List,Res),
    !.


nConflicts(Assignment,N,Out):-
    weekLevelConflicts(Assignment,N,Out),
    !.
weekLevelConflicts(Assignment,N,Out):-
    weekLevelConflicts(Assignment,0,N,0,Out),
    !.
weekLevelConflicts(_,I,N,Count,Out):-
    I>=(N*(N-1)),
    Out=Count,
    !.
weekLevelConflicts(Assignment,I,N,Count,Out):-
    End is I+(N/2)+1,
    slice(Assignment,I,End,GamesInWeek),
    flatten(GamesInWeek,TeamsInWeek),
    conflictsInWeek(Assignment,TeamsInWeek,GamesInWeek,0,C),
    Count2 is (Count+C),
    I2 is (End-1),
    weekLevelConflicts(Assignment,I2,N,Count2,Out),
    !.

conflictsInWeek(_,_,[],Count,Count):-!.
conflictsInWeek(Assignment,TeamsInWeek,[[A|[B]]|Rest],Count,Res):-
    conflictsInWeek(Assignment,TeamsInWeek,Rest,Count,Temp),
    
    count(TeamsInWeek,A,Ac),
    count(TeamsInWeek,B,Bc),
    count(Assignment,[A,B],Gc),
    (addToCount(Ac,Bc,Gc) -> Res is (Temp+1); Res is Temp),
    !.
addToCount(Ac,_,_):-
    Ac>1,
    !.
addToCount(_,Bc,_):-
    Bc>1,
    !.
addToCount(_,_,Gc):-
    Gc>1,
    !.





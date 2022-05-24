fitness(Individual,F):-
    nTeams(N),
    nConflicts(Individual,N,Conf),
    length(Individual,MaxConf),
    F is (1-(Conf/MaxConf)),
    !.


% The number of conflicts in an assignment.
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





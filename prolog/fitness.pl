% Determines the fitness of an individual.
% fitness(i,o).
fitness(Individual,F):-
    nTeams(N),
    nConflicts(Individual,N,Conf),
    length(Individual,MaxConf),
    onlyValidScore(OnlyValid),
    (
        OnlyValid-> Alt is 1; alterningScore(Individual,N,Alt)
    ),
    Temp is (0.95*(1-(Conf/MaxConf)))+(Alt*0.05),
    (
        Conf=:=0 -> Bonus is 1.0;
        Bonus is 0.0
    ),
    F is Temp+Bonus,
    !.

nConflicts(Assignment,N,Out):-
    nConflicts(Assignment,0,N,0,WeekConf),
    list_to_set(Assignment,Set),
    length(Set,S),
    A is (N*(N-1)),
    Out is WeekConf+((A-S)/A),
    !.
nConflicts(_,I,N,Count,Out):-
    I>=(N*(N-1)),
    Out=Count,
    !.
nConflicts(Assignment,I,N,Count,Out):-
    End is I+(N/2)+1,
    slice(Assignment,I,End,Slice),
    flatten(Slice,F),
    list_to_set(F,Set),
    length(Set,S2),
    Count2 is Count+(N-S2)/(N/2),
    I2 is (End-1),
    nConflicts(Assignment,I2,N,Count2,Out),
    !.
/* 
% The number of conflicts in an assignment.
% nConflicts(i,i,o).
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
 */
% Rewards an assignment for having teams alternate between
% home and visiting games.
% alterningScore(i,i,o).
alterningScore(Assignment,N,Out):-
    alterningScore(Assignment,1,N,Sum),
    Out is Sum/N,
    !.

alterningScore(_,Team,N,Sum):-
    Team>N,
    Sum is 0,
    !.
alterningScore(Assignment,Team,N,Sum):-
    Team2 is (Team+1),
    alterningScore(Assignment,Team2,N,Temp),
    teamGames(Assignment,Team,[[A|[_]]|Rest]),
    (
        A=:=Team -> Home is 1; Home is 0
    ),
    length(Rest,L),
    Ngames is (L-1),
    alterning(Rest,Team,Home,Alt),
    (
        Ngames=:=0 -> Sum is Temp;
        Sum is Temp+((Alt-1)/Ngames)
    ),
    !.

teamInGame(A,[A|[_]]):-!.
teamInGame(B,[_|[B]]):-!.
teamGames(Assignment,Team,Res):-
    include(teamInGame(Team),Assignment,Res),
    !.

alterning([],_,_,0):-!.
alterning([[_|[B]]|Rest],B,1,Alt):-
    alterning(Rest,B,0,Temp),
    Alt is Temp+1,
    !.
alterning([[A|[_]]|Rest],A,0,Alt):-
    alterning(Rest,A,1,Temp),
    Alt is Temp+1,
    !.
alterning([[A|[_]]|Rest],A,1,Alt):-
    alterning(Rest,A,1,Alt),
    !.
alterning([[_|[B]]|Rest],B,0,Alt):-
    alterning(Rest,B,0,Alt),
    !.
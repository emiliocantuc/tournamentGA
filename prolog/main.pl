
library(lists).
library(apply).
library(random).

:- dynamic population /1. % The current population
:- dynamic listOfGames /1. % The list of games to play


% Consult other files.
:- [inicialization,fitness,utils].

% Parameters 
n(300). 
nTeams(4).
propElite(0.1).
nElite(Res):-
    n(N),
    propElite(Prop),
    P is N*Prop,
    Res is floor(P),
    !.
nNonElite(Res):-
    nElite(E),
    n(N),
    Res is (N-E),
    !.
mutationRate(0.2).
temperature(0.8).
maxGens(100).

evolve:-
    % Set list of games to mutate faster
    nTeams(Nteams),
    games(Nteams,G),
    setGames(G),
    % Initialize population
    populate,
    % Evolve
    maxGens(M),
    evolve(0,M),
    !.
evolve(M,M):-!.
evolve(I,M):-!.



mutatePopulation:-
    population(Pop),
    mutatePopulation(Pop,[],New),
    setPopulation(New),
    !.
mutatePopulation([],Temp,Temp):-!.
mutatePopulation([I|Rest],Temp,New):-
    random(0.0,1.0,R),
    mutationRate(Mr),
    R<Mr,
    mutate(I,Mutated),
    append(Temp,[Mutated],Temp2),
    mutatePopulation(Rest,Temp2,New),
    !.
mutatePopulation([I|Rest],Temp,New):-
    append(Temp,[I],Temp2),
    mutatePopulation(Rest,Temp2,New),
    !.


% Linear 1 point crossover
% crossover(i,i,i,o,o):
crossover(A,B,Off1,Off2):-
    length(A,U),
    Upper is (U+1),
    random(1,Upper,Index),
    crossover(A,B,Index,Off1,Off2),
    !.
crossover(L1, L2, Index, H1, H2):-
    IM1 is Index-1,
    length(L1, Length1),
    slice(L1, 0, Index, L1P1),
    slice(L2, 0, Index, L2P1),
    Length is Length1+1,
    slice(L1, IM1, Length, L1P2),
    slice(L2, IM1, Length, L2P2),
    append(L1P1, L2P2, H1),
    append(L2P1, L1P2, H2).

% Replace a random game at a random index with a random game
mutate(Individual,Mutated):-
    listOfGames(Gs),
    random_member(Game,Gs),
    length(Individual,U),
    random(0,U,Index),
    replace(Individual,Index,Game,Mutated),
    !.


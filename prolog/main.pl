
library(lists).
library(apply).
library(random).
library(pairs).

:- dynamic population /1. % The current population
:- dynamic listOfGames /1. % The list of games to play


% Consult other files.
:- [inicialization,fitness,utils].

% Parameters 
n(100). % Size of population
nTeams(10). % Number of teams in tournament
propElite(0.05).
mutationRate(0.2).
coldness(0.8).
maxGens(2000).
maxWithoutImprovement(250).

% Derived parameters
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


evolve:-
    % Write parameters
    parameters,
    % Set list of games to mutate faster
    nTeams(Nteams),
    games(Nteams,G),
    setGames(G),
    % Initialize population
    populate,
    write("Initialized population with approx solutions"),nl,nl,
    % Evolve
    maxWithoutImprovement(M),
    evolve(1,0,-100,M),

    setOfValid(Out),
    length(Out,L),
    nl,write("Found "),write(L),write(" unique valid solution(s)."),nl,
    write("Writing them to output.txt"),nl,

    outputToFile("output.txt"),
    !.


newTimeSinceImprovement(_,LastMax,Max,NewTime,NewMax):-
    Max>LastMax,
    NewTime is 0,
    NewMax is Max,
    !.
newTimeSinceImprovement(LastTime,LastMax,_,NewTime,NewMax):-
    NewTime is (LastTime+1),
    NewMax is LastMax,
    !.

evolve(_,M,_,M):-!.
evolve(Gen,TimeSince,LastMax,M):-
    % Set aside elite
    elite(Elite),

    % Apply selection, crossover and mutation
    tournamentSelection,
    crossoverPopulation,
    mutatePopulation,

    % Append elite to population
    population(Pop),
    append(Elite,Pop,New),
    setPopulation(New),

    % Calculate fitness of individuals
    fitnesses(New,Fs),

    % Determine Time SInce Improvement
    max_list(Fs,CurrentMax),
    newTimeSinceImprovement(TimeSince,LastMax,CurrentMax,TimeSince2,Max2),

    % Write relevant generation statistics
    writeStatistics(Gen,Fs,TimeSince2),

    % Repeat
    Gen2 is (Gen+1),
    evolve(Gen2,TimeSince2,Max2,M),
    !.

elite(Res):-
    nElite(N),
    population(Pop),
    sortByFitness(Pop,Sorted),
    firstN(Sorted,N,Res),
    !.

% Tournament Selection
toAdd(Better,_,R,ToAdd):-
    coldness(T),
    R<T,
    ToAdd=Better,
    !.
toAdd(_,Worse,_,Worse):-!.

tournamentSelection:-
    nNonElite(N),
    tournamentSelection(0,N,[],New),
    setPopulation(New),
    !.
tournamentSelection(N,N,Temp,Temp):-!.
tournamentSelection(I,N,Temp,New):-
    population(Pop),
    random_member(A,Pop),
    random_member(B,Pop),
    betterAndWorse(A,B,Better,Worse),
    random(0.0,1.0,R),
    toAdd(Better,Worse,R,ToAdd),
    append([ToAdd],Temp,Temp2),
    I2 is (I+1),
    tournamentSelection(I2,N,Temp2,New),
    !.
% Mutate population
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


% Operators

crossoverPopulation:-
    nNonElite(N),
    Half is N/2,
    crossoverPopulation(0,Half,[],New),
    setPopulation(New),
    !.
crossoverPopulation(I,N,Temp,Temp):-
    I>=N,
    !.
crossoverPopulation(I,N,Temp,New):-
    population(Pop),
    random_member(A,Pop),
    random_member(B,Pop),
    crossover(A,B,Off1,Off2),
    append([Off1,Off2],Temp,Temp2),
    I2 is (I+1),
    crossoverPopulation(I2,N,Temp2,New),
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



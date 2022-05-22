
library(lists).
library(apply).
library(random).

:- dynamic population /1. % The current population


% Consultamos los demas archivos.
:- [inicialization,fitness,utils].

% Parametros 
n(500).
nTeams(8).
mutationRate(0.2).
temperature(0.8).


%crossover(i,i,i,o,o):
%El índice se cuenta desde 1
crossover(L1, L2, Indice, H1, H2):-
    IM1 is Indice-1,
    length(L1, Length1),
    slice(L1, 0, Indice, L1P1),
    slice(L2, 0, Indice, L2P1),
    Length is Length1+1,
    slice(L1, IM1, Length, L1P2),
    slice(L2, IM1, Length, L2P2),
    append(L1P1, L2P2, H1),
    append(L2P1, L1P2, H2).


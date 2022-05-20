
library(lists).
library(apply).


n(8).

% games(i,o). Genera una lista de partidos dado n equipos
sig(A,N,N,SigA,SigB):-
    SigA is (A+1),
    SigB is 1,
    !.
sig(A,B,_,A,SigB):-
    SigB is (B+1),
    !.
games(N):-
    games(1,1,N,Temp),
    write(Temp),
    !.
games(N,Res):-
    games(1,1,N,Res),
    !.
games(N,B,N,[[N,B]]):-
    B=:=(N-1),
    !.
games(A,A,N,Res):-
    sig(A,A,N,A2,B2),
    games(A2,B2,N,Res),
    !.
games(A,B,N,Res):-
    sig(A,B,N,A2,B2),
    games(A2,B2,N,Temp),
    append(Temp,[[A,B]],Res),
    !.





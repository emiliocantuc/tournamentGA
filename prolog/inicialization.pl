populate():-
    n(N),
    


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

% Random games
randomAssignment(N,Res):-
    games(N,Temp),
    random_permutation(Temp,Res),
    !.

% Available
available(Remaining,Week,Res):-
    subtract(Remaining,Week,Res),
    !.

% Game to Add
gameToAdd(Remaining,Week,Game):-
    available(Remaining,Week,Available),
    length(Available,La),
    La>0,
    random_member(Game,Available),
    !.
gameToAdd(Remaining,_,Game):-
    random_member(Game,Remaining),
    !.
approx(N,Out):-
    randomAssignment(N,Remaining),
    K is N/2,
    approx(Remaining,[],K,[],Out),
    !.
approx(Remaining,_,_,Res,Out):-
    length(Remaining,Lr),
    Lr=:=0,
    Out=Res,
    !.

approx(Remaining,Week,K,Res,Out):-
    length(Remaining,Lr),
    Lr>0,
    gameToAdd(Remaining,Week,Game),
    % Add to Res
    append(Res,[Game],Res2),
    % Add to Week
    append([Game],Week,Week2),
    % Adjust week
    take(Week2,K,Week3),
    % Remove from remaining
    subtract(Remaining,[Game],Remaining2),
    % Recursive call
    approx(Remaining2,Week3,K,Res2,Out),
    !.
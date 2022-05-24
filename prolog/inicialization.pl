% Fills population with n approx individuals.
populate:-
    n(N),
    populate(0,N,[],Pop),
    setPopulation(Pop),
    !.
%populate(i,i,i,o).
populate(N,N,Pop,Pop):-!.
populate(I,N,Temp,Pop):-
    I=<N,
    nTeams(Nteams),
    approx(Nteams,New),
    append([New],Temp,Pop2),
    I2 is I+1,
    populate(I2,N,Pop2,Pop),
    !.

% Generates the list of games to be played as a function of n.
% Writes generated games (for debugging).
% games(i).
games(N):-
    games(1,1,N,Temp),
    write(Temp),
    !.
% games(i,o).
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
% Used in games. Determines next values for A and B.
sig(A,N,N,SigA,SigB):-
    SigA is (A+1),
    SigB is 1,
    !.
sig(A,B,_,A,SigB):-
    SigB is (B+1),
    !.

% A random permutation of games(N).
% randomAssignment(i,o).
randomAssignment(N,Res):-
    games(N,Temp),
    random_permutation(Temp,Res),
    !.

% Generates a random approximate assignment greedily. Used at inicialization.
% Tries to add games not in week while possible. It otherwise adds
% a random game from games.
% approx(i,o).
approx(N,Out):-
    games(N,Remaining),
    K is N/2,
    approx(Remaining,[],K,[],Out),
    !.
% approx(i,i,i,i,o).
approx(Remaining,_,_,Res,Out):-
    length(Remaining,Lr),
    Lr=:=0,
    Out=Res,
    !.
approx(Remaining,Week,K,Res,Out):-
    length(Week,L),
    L=:=K,
    approx(Remaining,[],K,Res,Out),
    !.
approx(Remaining,Week,K,Res,Out):-
    length(Remaining,Lr),
    Lr>0,
    gameToAdd(Remaining,Week,Game),
    % Add to Res
    append(Res,[Game],Res2),
    % Add to Week
    append([Game],Week,Week2),
    % Remove from remaining
    subtract(Remaining,[Game],Remaining2),
    % Recursive call
    approx(Remaining2,Week2,K,Res2,Out),
    !.


% Used in approx. Determines which game to add next to assignment.
% If there are "available" games, choose one at random.
% Otherwise choose a random game from games.
% gameToAdd(i,i,o).
gameToAdd(Remaining,Week,Game):-
    available(Remaining,Week,Available),
    length(Available,La),
    La>0,
    random_member(Game,Available),
    !.
gameToAdd(Remaining,_,Game):-
    random_member(Game,Remaining),
    !.
    
% Used in approx. Games in Remaining not in week.
% available(i,i,o).
gameTeamsInWeek(TeamsInWeek,[A|[B]]):-
    count(TeamsInWeek,A,Ac),
    Ac=:=0,
    count(TeamsInWeek,B,Bc),
    Bc=:=0,
    !.
available(Remaining,Week,Res):-
    flatten(Week,TeamsInWeek),
    include(gameTeamsInWeek(TeamsInWeek),Remaining,Res),
    !.


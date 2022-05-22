fitness(Individual,F):-
    nTeams(N),
    nConflicts(Individual,N,Conf),
    F is Conf*(-1),
    !.


betterAndWorse(A,B,Better,Worse):-
    fitness(A,Fa),
    fitness(A,Fb),
    Fa>Fb,
    Better is A,
    Worse is B,
    !.
betterAndWorse(A,B,B,A):-!.

nConflicts(Assignment,N,Out):-
    nConflicts(Assignment,0,N,0,Out),
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
    length(F,S1),
    length(Set,S2),
    Count2 is Count+(S1-S2),
    I2 is (End-1),
    nConflicts(Assignment,I2,N,Count2,Out),
    !.



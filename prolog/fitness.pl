
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



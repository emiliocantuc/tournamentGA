take(Src,N,L) :- findall(E, (nth1(I,Src,E), I =< N), L).

slice(L, From, To, R):-
  length(LFrom, From),
  length([_|LTo], To),
  append(LTo, _, L),
  append(LFrom, R, LTo).

% ********** PART 1 **********

%search2 (Elem , List )
% looks for two consecutive occurrences of Elem
search2(E, [E, E | _]).
search2(E, [_ | T]) :- search2(E, T).

% search_two (Elem , List )
% looks for two occurrences of Elem with any element in between !
search_two(E, [E, _, E | T]).
search_two(E, [H | T]) :- search_two(E, T).

% size (List , Size )
% Size will contain the number of elements in List
size([], 0).
size([_ | T], N) :- size(T, R), N is R + 1.

% sum(List , Sum )
sum([], 0).
sum([H | T], N) :- sum(T, R), N is R + H.

% max_min(List ,Max , Min )
% Max is the biggest element in List
% Min is the smallest element in List
% Suppose the list has at least one element
max([], CurrMax, CurrMax).
max([H|T], CurrMax, Max) :- H > CurrMax, max(T, H, Max).
max([H|T], CurrMax, Max) :- H =< CurrMax, max(T, CurrMax, Max).
max([H | T], Max) :- max(T, H, Max).

min([], CurrMin, CurrMin).
min([H|T], CurrMin, Min) :- H < CurrMin, min(T, H, Min).
min([H|T], CurrMin, Min) :- H >= CurrMin, min(T, CurrMin, Min).
min([H | T], Min) :- min(T, H, Min).

max_min(L, Max, Min) :- max(L, Max), min(L, Min).

% split (List1 , Elements , SubList1 , SubList2 )
% Splits a list into two sublists based on a given setof elements .
% example : split ([10 ,20 ,30 ,40 ,50] ,2 ,L1 ,L2). -> L1/[10 ,20] L2 /[30 ,40 ,50]
% trying to split an empty list at element > 0 will result in NO
split(L, 0, [], L).
split([H | T], N, [H | R], L2) :- N2 is N - 1, split(T, N2, R, L2).

% rotate (List , RotatedList )
% Rotate a list , namely move the first element to theend of the list .
% example : rotate ([10 ,20 ,30 ,40] , L). -> L /[20 ,30 ,40 ,10]
rotate([], E, [E]).
rotate([H|T], E, [H|RL]) :- rotate(T, E, RL).
rotate([], []).
rotate([H|T], RL) :- rotate(T, H, RL).

% dice(X)
% Generates all possible outcomes of throwing a dice.
% example: dice(X): X/1; X/2; ... X/6
dice(N, N).
dice(I, X) :- Next is I + 1, Next < 7, dice(Next, X).
dice(X) :- dice(1, X).

% three_dice(5, L).
% Generates all possible outcomes of throwing three dices
% exmple: three_dice(5, L). -> L/[1,1,3]; L/[1,2,2];...;L/[3,1,1]
three_dice(L) :- dice(X), dice(Y), dice(Z), L = [X, Y, Z].


% ********** PART 2 **********

% dropAny(?Elem,?List,?OutList)
dropAny(X, [X | T], T).
dropAny(X, [H | Xs], [H | L]) :- dropAny(X, Xs, L).

dropFirst(E, L, LO) :- dropAny(E, L, LO), !.

% didn't find a simpler solution than reversing the list and applying dropFirst
my_reverse([], []).
my_reverse([], LO, LO).
my_reverse([H | T], Acc, LO) :- my_reverse(T, [H|Acc], LO). 
my_reverse([H | T], LO) :- my_reverse(T, [H], LO). 
dropLast(X, L, LO) :- my_reverse(L, RL), dropFirst(X, RL, RLO), my_reverse(RLO, LO).

dropAll(X, [], []). % added
dropAll(X, [CX | T], L) :- copy_term(X, CX), dropAll(X, T, L), !. % modified
dropAll(X, [H | Xs], [H | L]) :- dropAll(X, Xs, L). % untouched


% ********** PART 3 **********

% fromList(+List,-Graph)
fromList([_],[]).
fromList([H1,H2|T],[e(H1,H2)|L]):- fromList([H2|T],L).

% fromCircList(+List,-Graph)
appendLast([], E, [E]).
appendLast([H|T], E, [H|LO]) :- appendLast(T, E, LO).

fromCircList([H|T], G) :- appendLast([H|T], H, LO), fromList(LO, G).

% more complex but faster version which uses a var to remember the first element
fromCircList_fast([Last], First,[e(Last, First)]).
fromCircList_fast([H1,H2|T], FirstE,[e(H1,H2)|L]):- fromCircList_fast([H2|T] ,FirstE, L).
fromCircList_fast([H|T], G) :- fromCircList_fast([H|T], H, G).

% outDegree(+Graph, +Node, -Deg)
% Deg is the number of edges which start from Node
outDegree([], N, 0).
outDegree([e(N,_)|T], N, D) :- outDegree(T, N, D1), D is 1 + D1, !.
outDegree([H|T], N, D) :- outDegree(T, N, D).

% dropNode(+Graph, +Node, -OutGraph)
% drop all edges starting and leaving from a Node % use dropAll defined in 1.1??
dropNode(G,N,OG) :- dropAll(e(N,_),G, G2), dropAll(e(_,N),G2,OG).

% reaching(+Graph, +Node, -List)
% all the nodes that can be reached in 1 step from Node
% possibly use findall , looking for e(Node ,_) combined
% with member(?Elem,?List)
reaching(G, N, LO) :- findall(X, member(e(N,X), G), LO).

% nodes (+Graph , -Nodes)
% create a list of all nodes (no duplicates) in the graph (inverse of fromList)
% I KNOW IT'S NOT EFFICIENT BUT IT'S SIMPLE
append_unique([], E, [E]).
append_unique([E|T], E, [E|T]) :- !.
append_unique([H|T], E, [H|LO]) :- append_unique(T, E, LO).

nodes([e(A,B)], N) :- append_unique([A], B, N), !.
nodes([e(A,B)|T], N) :- nodes(T, NR), append_unique(NR, A, NR2), append_unique(NR2, B, N).


% anypath(+Graph, +Node1, +Node2, -ListPath)
% a path from Node1 to Node2
% if there are many path , they are showed 1-by -1
% WORKS BUT SHOWS SOME DUPLICATED PATHS example: anypath([e(5,6),e(2,3),e(3,4),e(2,4)],2,4,L).
anypath([e(N1,N2)|_], N1, N2, [e(N1,N2)]).
anypath([e(A,B)|T], N1, N2, LPR) :- anypath(T, N1, N2, LPR).
anypath(G, N1, N2, [e(N1,N3)|LP]) :- reaching(G, N1, N3L), member(N3, N3L), anypath(G, N3, N2, LP).


% ********** PART 4 **********

% T is a list of cells from top left to bottom right row by row.
% cells can be 'x', 'o' or 'e' where e stands for empty
% Result can be 'x', 'o', 'even' or 'nothing' where nothing stands for a T without winners which can be played more
result([R,R,R,_,_,_,_,_,_], R) :- R \= e, !. % first row
result([_,_,_,R,R,R,_,_,_], R) :- R \= e, !. % second row
result([_,_,_,_,_,_,R,R,R], R) :- R \= e, !. % third row
result([R,_,_,R,_,_,R,_,_], R) :- R \= e, !. % first column
result([_,R,_,_,R,_,_,R,_], R) :- R \= e, !. % second column
result([_,_,R,_,_,R,_,_,R], R) :- R \= e, !. % third column
result([R,_,_,_,R,_,_,_,R], R) :- R \= e, !. % top-left to bottom-right diagonal
result([_,_,R,_,R,_,R,_,_], R) :- R \= e, !. % top-right to bottom-left diagonal
result([E], even) :- E \= e, !.
result([H|T], R) :- H \= e, result(T, R), !.
result([H|T], nothing).

next(T, P, R, NT) :- next(T, P, NT), result(NT, R). % just start the computation and return a result for the new T

next([e], P, [P]) :- !.
next([e|T], P, [P|T]).
next([e|T], P, [e|NT]) :- next(T, P, NT).
next([M|T], P, [M|NT]) :- M \= e, next(T, P, NT).

other_player(x, o).
other_player(o, x).

% R (Result) is passed along as the result of the last next and is used to determine if recursion should continue
% when R is \= from nothing then it is "returned" as RO (ResultOutput) which is the actual output of the game.
game(T, P, R, R, []) :- R \= nothing, !.
game(T, P, R, RO, [NT|NTR]) :- next(T, P, NR, NT), other_player(P, OP), game(NT, OP, NR, RO, NTR).
game(T, P, R, LT) :- game(T, P, nothing, R, LT).

% test using:
%   game([x,o,e,e,e,e,e,e,e], x, R, NT)
% as starting from an empty T gives time overflow
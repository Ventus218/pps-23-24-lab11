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


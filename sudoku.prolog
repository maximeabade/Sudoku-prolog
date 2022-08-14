:-use_module(library(clpfd)).

sudoku() :-
    % lire le contenu du fichier csv
    csv_read_file('sudoku.csv', Rows, []),
    to_matrice(Rows,Matrice),
    % on aplique une contrainte pour dire que les valeurs sont comprises entre 1 et 9 et tous différentes
    maplist(my_domain,Matrice),
    % on transpose la matrice pour avoir accés aux colonnes
    transpose(Matrice,Transpose),
    % on pose une nouvelle contrainte : les éléments d'une colonne sont différents
    maplist(all_distinct,Transpose),
    % contrainte des bloc de 3 x 3
    block(Matrice),
    % on affiche la matrice
    afficher_matrice(Matrice).

to_matrice([],[]).

to_matrice([X|Q],Matrice) :-
    % transformer une ligne en liste
    X =.. [_|L],
    % remplacer les '_' par des variables sur la liste
    maplist(clean,L,Lclean),
    % on répète pour chaque ligne
    to_matrice(Q,Matrice2),
    % résultat :
    Matrice = [Lclean|Matrice2].

afficher_matrice([]).

afficher_matrice([X|Q]) :-
    write_ln(X),
    afficher_matrice(Q).

clean(Elem,ElemClean) :-
    Elem = '_',
    ElemClean = _.

clean(Elem,ElemClean) :-
    Elem \= '_',
    ElemClean = Elem.

my_domain(L) :- 
    L ins 1..9, 
    all_distinct(L).

block([]).

block([L1,L2,L3|Q]) :-
    % on traite les 3 premières lignes
    block_ligne(L1,L2,L3),
    %on fait l'appel récursif sur les 3 prochaines lignes
    block(Q).

block_ligne([],[],[]).

block_ligne([X11,X12,X13|L1],[X21,X22,X23|L2],[X31,X32,X33|L3]) :-
    % on traite les 3 premières valeurs de chaque ligne et on vérifie si elles sont diférentes
    all_distinct([X11,X12,X13,X21,X22,X23,X31,X32,X33]),
    block_ligne(L1,L2,L3).
# Build and dependencies

# Systèmes de build - TP1: makefile

## Préambule

Ecrire un makefile, dont le travail est de manipuler des fichiers .dot et de les
transformer en .png

DOT est un langage qui permet de définir des graphes, c'est à dire un ensemble
de noeuds et de relations

Pour installer make

    apt-get update
    apt-get install make

Pour installer dot

    apt-get update
    apt-get install graphviz


## A. Convertir un .dot en .png

Ecrire une _cible_ `build` qui convertir le fichier `graph.dot` en `graph.png`

Rappel: la commande pour convertir un .dot en .png est la suivante:

    dot graph.dot -Tpng > graph.png

## B. Lister les fichiers .dot

Ecrire une _cible_ `list` qui liste tous les fichiers `.dot` du dossier courant

Note: vous pouvez utiliser l'instruction `wildcard` pour remplir une variable

## C. Lister les fichiers .png

Ecire une _cible_ `destlist` qui liste tous les fichiers `.png` qui devront
être produit depuis les `.dot` 

Note: vous pouvez utiliser l'instruction `patsubst` pour réécrire le contenu
d'une variable

## D. Convertir un .dot en .png (bis)

Ecrire une _cible_ générique `%.png` (qui prend en entrée un .dot) et qui
génère le fichier png ciblé

## E. Améliorer build

Adaptez la _cible_ `build` pour utiliser la règle générique plutot que d'agir
sur un unique fichier.

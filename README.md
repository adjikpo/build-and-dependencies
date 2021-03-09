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

# TP2 - Dépendances et règles dynamiques

## Objectif du TP

On souhaite écrire le processus de build pour produire un livre en PDF, d'après un ensemble de fichiers texte au format Markdown (`*.md`) et d'images.

L'arborescence du projet ressemblera à celle ci-dessous, dans laquelle le répertoire `docs` existera dans tous les cas, mais les fichiers et dossiers qu'ils contient (leurs nom, leurs organisation, etc.) pourront changer.

     .
     |- docs/
     |   |- c01-intro/
     |   |   |- section1.md
     |   |   `- section2.md
     |   |   
     |   |- c02-definitions/
     |   |   |- motA.md
     |   |   `- motB.md
     |   |   
     |   |- c03-blabla/
     |   |   `- blabla.md
     |   |   
     |   |- c01-intro.md
     |   |- c02-definition.md
     |   |- c03-blabla.md
     |   `- livre.md
     |   
     |- images/
     |- build/
     `- Makefile


## Outillage

## MarkdownPP pour les includes entre fichiers

Dans le dossier `docs` les fichiers Markdown pourront faire référence les uns aux autres.

Pour cela, nous allons utiliser la syntaxe proposée par le logiciel MarkdownPP disponible sur <https://github.com/jreese/markdown-pp>

La syntaxe est la suivante :

    !INCLUDE "FICHIER", DECALAGE

* où `FICHIER` est le chemin relatif du fichier soit depuis le fichier courant (soit  depuis la racine du projet si ça vous arrange).
* où `DECALAGE` est le niveau de titre en dessous duquel les titres du fichiers inclus devront être décalés (ex: un fichier avec un H1 décalé de 2 devient un H3)


### Exemple

Soit le fichier `c01-intro.md`

    # Chapitre 01 : Introduction
    
    ## Préambule
    
    Blabla du préambule
    
    !INCLUDE "c01-intro/section1.md", 1
    !INCLUDE "c01-intro/section2.md", 1
    
    ## End of story

Soit le fichier `c01-intro/section1.md`

    # Je suis la section 1 
    
    Blabla de la section 1

Soit le fichier  `c01-intro/section2.md`

    # Je suis la section 2 
    
    Blabla de la section 2

En lançant la commande

    $ markdown-pp build/c01-intro.md -o out.md

On obtiendra à la fin dans `out.md` :

    # Chapitre 01 : Introduction
    
    ## Préambule
    
    Blabla du préambule
        
    ## Je suis la section 1 
    
    Blabla de la section 1
    
    ## Je suis la section 2  
    
    Blabla de la section 2
    
    ## End of story


Pour cela on construira d'abord des fichiers intermédiaires, regroupant les différents fichiers Markdown (`*.md`) en respectant les références fait par les uns vers les autres.

### Pandoc pour le PDF

Pour générer le PDF on utilisera la commande `pandoc` comme suit

    pandoc -fmarkdown -tpdf -o livre.pdf build/livre.md


## Étapes

### A. Lister tous les fichiers .md en entrée et en sortie

* définir une variable `MD_SRC_FILES` qui liste les fichiers .md du dossier docs/
* définir une variable `MD_BUILD_FILES` qui liste les futurs équivalents dans le
  dossier build/

### B. Générer la liste des dépendances

Écrire une target _depend_ qui regarde les !INCLUDE et fabrique un fichier
`.depend` de la forme suivante :

```
build/livre.md: build/c01-intro.md
build/livre.md: build/c02-definitions.md
build/livre.md: build/c03-blabla.md
build/c01-intro.md: build/c01-intro/section1.md
build/c01-intro.md: build/c01-intro/section2.md
build/c01-intro/section1.md: docs/c01-intro/section1.md
build/c01-intro/section2.md: docs/c01-intro/section2.md
build/c02-definitions.md: build/c02-definitions/motA.md
build/c02-definitions.md: build/c02-definitions/motB.md
[... etc. ...]
```

On pourra utiliser pour cela sed, sur chacun des fichiers identifiés, afin de générer
une ligne par fichier d'entrée. Par exemple pour un fichier `f1.md` :

    f1.md: $(sed -n '/!INCLUDE/ { s/!INCLUDE "\(.*\)".*/\1/ p  }' f1.md )

Par la suite il faudra utiliser ce fichier `.depend` dans le Makefile à l'aide de l'instruction `-include` .

### C. Générer les fichiers intermédiaires

Écrire des cibles pour Makefile, qui permettent 

* de générer les fichiers dans `build/%.md` depuis `docs/%.md`
* d'effacer les fichiers `build/%.md`

Astuce: 

* quand le fichier contient un `!INCLUDE`, il faut le générer avec markdown-pp
* quand le fichier ne contient pas de `!INCLUDE`, on peut faire un cp

### D. Générer un pdf

Écrire une cible pour Makefile permettant de générer un fichier pdf (dans build) depuis le fichier `build/livre.md`.

### E. Questions ouvertes

* Comment pourrait-on faire un projet pour construire plusieurs PDF ?
* Comment distinguer les fichiers Markdown qui donneront des PDF de ceux qui n'en donneront pas ?

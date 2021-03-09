## On souhaite avoir l'arborescence suivante
# .
# |- hello
# |   |- lib.c
# |   `- main.c
# `- hello2
#     `- world.c
#
## On souhaite générer les binaires suivants
# - build/hello à partir du dossier hello
# - build/world à partir du dossier hello2

PROGRAMS=hello world again

hello_BIN=hello
hello_DIR=hello
hello_FILES=main.c lib.c

world_BIN=world
world_DIR=hello2
world_FILES=world.c

again_BIN=again
again_DIR=hello3
again_FILES=world.c

include magic.mk

zip:
	zip -r $$(basename $$(pwd)).zip .

zip_clean: 
	rm -f $$(basename $$(pwd)).zip

clean: zip_clean

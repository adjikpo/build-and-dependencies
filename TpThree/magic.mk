## Rappel makefile
# a: b c d e
# 	$@  => a
# 	$<  => b
# 	$^  => b c d e
# 	$$  => $

#
## On se souvient que pour compiler du C, ça se passe dans cet ordre là
#
# SRC   OBJ   BIN
# .c => .o => bin
#
## On aura surement les dépendances suivantes

# hello_FILES= ...
# hello_OBJS=$(patsubst %.c,%.o,$(hello_FILES))
#
# hello/%.o: hello/%.c
#     gcc -c -o ...
#
# build/hello: $(hello_OBJS)
#     gcc -o ...


## DANGER= si je fais $($(1)_truc)) => make va mal comprendre le contenu
## TECHNIQue/ASTUCE
##  $$( ) => pas interprété a la premiere passe
##  $( ) => interprété à la premiere passe

# bloc de code avec target_BIN , target_DIR, target_FILES
# * remplacer les $ par des $$
# * remplacer target_ par $(1)_

define PROGRAM_tpl
$(1)_FILES_WITH_DIR=$$(addprefix $$($(1)_DIR)/,$$($(1)_FILES))
$(1)_OBJS=$$(patsubst %.c,%.o,$$($(1)_FILES_WITH_DIR))

$$($(1)_DIR)/%.o: $$($(1)_DIR)/%.c
	gcc -c -o $$@ $$<

build/$$($(1)_BIN): $$($(1)_OBJS)
	mkdir -p build
	gcc -o $$@ $$^

$(1)_clean:
	rm -f build/$$($(1)_BIN)
	rm -f $$($(1)_OBJS)

clean: $(1)_clean

build: build/$$($(1)_BIN)

endef

$(foreach group,$(PROGRAMS),$(eval $(call PROGRAM_tpl,$(group))))


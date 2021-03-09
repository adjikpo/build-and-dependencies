DOT_FILES =$(wildcard *.dot) 
PNG_FILES = $(patsubst % .dot , %.dot.png,  $(DOTFILES))

all:
	@echo "Hello world"

build: $(PNG_FILES )

include dot.mk
DOTFILES =$(wildcard *.dot) 
PNGFILES = $(patsubst % .dot , %.png,  $(DOTFILES))

build:  $(PNGFILES)

list: 
	@echo $(DOTFILES)

destlist:
	@echo $(PNGFILES)

%.png: %.dot
	dot  $<  -Tpng >  $@

clean:
	rm *.png
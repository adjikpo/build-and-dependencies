dotFiles =$(wildcard *.dot) 
pngFiles = $(patsubst % .dot , %.png,  $(dotFiles))

build:  $(pngFiles)

list: 
	@echo $(dotFiles)

destlist:
	@echo $(pngFiles)

%.png: %.dot
	dot  $<  -Tpng >  $@

clean:
	rm *.png
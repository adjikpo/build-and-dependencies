%.dot.png: %.dot
	dot -Tpng $< > $@
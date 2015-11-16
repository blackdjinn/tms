.PHONY: print
print :
	rm -f state.txt
	git status > state.txt
	git log -8 >> state.txt
	a2ps -C -v --toc -g --sides=2 state.txt src/* lib/*

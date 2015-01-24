.PHONY: print
print :
	rm -f state.txt
	git status > state.txt
	git log -8 >> state.txt
	a2ps -C -v --toc -g state.txt src/* lib/*

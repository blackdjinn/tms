all: manual.dvi manual.pdf

manual.dvi: manual.tex
	rubber manual.tex

manual.pdf: manual.tex
	rubber -d manual.tex

clean:
	rubber --clean manual.tex
	rubber --clean -d manual.tex

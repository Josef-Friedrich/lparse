jobname = lparse
texmf = $(HOME)/texmf
texmftex = $(texmf)/tex/luatex
installdir = $(texmftex)/$(jobname)

all: test doc

install:
	mkdir -p $(installdir)
	cp -f $(jobname).lua $(installdir)
	cp -f $(jobname).sty $(installdir)
	cp -f $(jobname).tex $(installdir)

doc: doc_pdf

doc_pdf:
	lualatex --shell-escape lparse-doc.tex
	makeindex -s gglo.ist -o lparse-doc.gls lparse-doc.glo
	makeindex -s gind.ist -o lparse-doc.ind lparse-doc.idx
	lualatex --shell-escape lparse-doc.tex
	mkdir -p $(texmf)/doc
	cp lparse-doc.pdf $(texmf)/doc/$(jobname).pdf

ctan: doc_pdf
	rm -rf $(jobname).tar.gz
	rm -rf $(jobname)/
	mkdir $(jobname)
	cp -f README.md $(jobname)/
	cp -f $(jobname).lua $(jobname)/
	cp -f $(jobname).sty $(jobname)/
	cp -f $(jobname).tex $(jobname)/
	cp -f lparse-doc.pdf $(jobname)/$(jobname).pdf
	cp -f lparse-doc.tex $(jobname)/
	tar cvfz $(jobname).tar.gz $(jobname)
	rm -rf $(jobname)

debug:
	luatex tests/luatex/test_default.tex

test: install test_lua test_tex

test_lua:
	busted --lua=/usr/bin/lua5.3 --exclude-tags=skip tests/lua/test-*.lua

test_tex: test_tex_plain
test_tex_plain:
	find tests/tex/luatex -iname "*.tex" -exec luatex --output-dir=tests/tex/luatex {} \;

clean:
	git clean -d -x --force

.PHONY: all install clean

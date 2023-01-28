jobname = lparse
texmf = $(HOME)/texmf
texmftex = $(texmf)/tex/luatex
installdir = $(texmftex)/$(jobname)

all: install

install:
	mkdir -p $(installdir)
	cp -f $(jobname).lua $(installdir)

debug:
	luatex tests/luatex/test_default.tex

test: install test_lua

test_lua:
	busted --lua=/usr/bin/lua5.3 --exclude-tags=skip tests/lua/test-*.lua

test_tex: test_tex_plain
test_tex_plain:
	find tests/tex/luatex -iname "*.tex" -exec luatex --output-dir=tests/tex/luatex {} \;

clean:
	git clean -d -x --force

.PHONY: all install clean

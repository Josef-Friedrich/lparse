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

clean:
	git clean -d -x --force

.PHONY: all install clean

# lparse

Parse and scan macro arguments in `Lua` with `LuaTeX` using a `xparse`
like argument specification.

The name `lparse` is derived from `xparse`. The `x` has been replaced by
`l` because this package only works with `LuaTeX`. `l` stands for *Lua*.
Just as with `xparse`, it is possible to use a special syntax consisting
of single letters to express the arguments of a macro. However, `lparse`
is able to read arguments regardless of the macro systemd used - whether
`LaTeX` or `ConTeXt` or even plain `TeX`. Of course, `LuaTeX` must
always be used as the engine.

## Current version

2025/06/19 v0.2.0

## License

Copyright (C) 2023-2025 by Josef Friedrich <josef@friedrich.rocks>
------------------------------------------------------------------------
This work may be distributed and/or modified under the conditions of
the LaTeX Project Public License, either version 1.3c of this license
or (at your option) any later version.  The latest version of this
license is in:

  http://www.latex-project.org/lppl.txt

and version 1.3c or later is part of all distributions of LaTeX
version 2008/05/04 or later.

## Maintainer

Josef Friedrich <josef@friedrich.rocks>

## Packaging

### CTAN

The `lparse` package has been included in the Comprehensive TeX Archive
Network (CTAN) since January 2023.

* [Package page](https://www.ctan.org/pkg/lparse)
* [Sources](https://www.ctan.org/tex-archive/macros/luatex/generic/lparse)

### Distributions

* TeX Live:
  * run files:
    * [tex/luatex/lparse/lparse.lua](https://tug.org/svn/texlive/trunk/Master/texmf-dist/tex/luatex/lparse/lparse.lua)
    * [tex/luatex/lparse/lparse.tex](https://tug.org/svn/texlive/trunk/Master/texmf-dist/tex/luatex/lparse/lparse.tex)
    * [tex/luatex/lparse/lparse.sty](https://tug.org/svn/texlive/trunk/Master/texmf-dist/tex/luatex/lparse/lparse.sty)
  * doc files:
    * [doc/luatex/lparse/lparse-doc.tex](https://tug.org/svn/texlive/trunk/Master/texmf-dist/doc/luatex/lparse/lparse-doc.tex)
    * [doc/luatex/lparse/lparse-doc.pdf](https://tug.org/svn/texlive/trunk/Master/texmf-dist/doc/luatex/lparse/lparse-doc.pdf)
    * [doc/luatex/lparse/README.md](https://tug.org/svn/texlive/trunk/Master/texmf-dist/doc/luatex/lparse/README.md)
* [MiKTeX](https://miktex.org/packages/lparse)

### Repository

The [Git repository](https://github.com/Josef-Friedrich/lparse) in which
the development takes place is hosted on [GitHub](https://github.com).

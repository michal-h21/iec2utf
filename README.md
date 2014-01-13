iec2utf.lua
===========

This is simple script to convert files writen by LaTeX `inputenc` package
with `utf-8` option.

Usage
-----

    texlua iec2utf.lua "used fontenc" < filename > newfile

You must specify font encodings used in the document, default is T1, used in
European languages wth Latin alphabet.

Example
-------

For example, this sample:

    \documentclass{article}

    \usepackage[T1]{fontenc}
    \usepackage[utf8]{inputenc}
    \usepackage[]{makeidx}
    \makeindex
    \begin{document}
      Hello
      \index{Příliš}
      \index{žluťoučký}
      \index{kůň}
      \index{úpěl}
      \index{ďábelské}
      \index{ódy}
      \printindex
    \end{document}

produces this raw index file:

    \indexentry{P\IeC {\v r}\IeC {\'\i }li\IeC {\v s}}{1}
    \indexentry{\IeC {\v z}lu\IeC {\v t}ou\IeC {\v c}k\IeC {\'y}}{1}
    \indexentry{k\IeC {\r u}\IeC {\v n}}{1}
    \indexentry{\IeC {\'u}p\IeC {\v e}l}{1}
    \indexentry{\IeC {\v d}\IeC {\'a}belsk\IeC {\'e}}{1}
    \indexentry{\IeC {\'o}dy}{1}

When you try to process this index file with xindy:

    texindy -M lang/czech/utf8-lang

the result is incorrect:

      \item \IeC {\'o}dy, 1
      \item \IeC {\'u}p\IeC {\v e}l, 1
      \item \IeC {\v d}\IeC {\'a}belsk\IeC {\'e}, 1
      \item \IeC {\v z}lu\IeC {\v t}ou\IeC {\v c}k\IeC {\'y}, 1

      \indexspace

      \item k\IeC {\r u}\IeC {\v n}, 1

      \indexspace

      \item P\IeC {\v r}\IeC {\'\i }li\IeC {\v s}, 1

We must convert the `.idx` file to `utf8` encoding in order to be processed
correctly with `xindy`:

    texlua iec2utf.lua < filename.idx > new.idx
    mv new.idx filename.idx
    texindy -M lang/czech/utf8-lang

The result is now correct:

      \lettergroup{D}
      \item ďábelské, 1

      \indexspace

      \lettergroup{K}
      \item kůň, 1

      \indexspace

      \lettergroup{O}
      \item ódy, 1

      \indexspace

      \lettergroup{P}
      \item Příliš, 1

      \indexspace

      \lettergroup{U}
      \item úpěl, 1

      \indexspace

      \lettergroup{Ž}
      \item žluťoučký, 1




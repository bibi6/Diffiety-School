Diffiety-School
===============

This is a project for Diffiety-School site. We hope to enable MathJax and be able to post notes here. Later on it may also host Tex files on which we collaborate and corresponding pdf files with compiled versions of the tex notes.

## Website

Available by [clicking here](http://diffietyschool.github.io/Diffiety-School/).

##Repositories

The only repository for now is gh-pages, for the website. Other repos may be added in the future, to host other files.

##Contributing

Just fork, edit the web pages in the subdirectory src/html, and make a pull request. Just as simple as that :)

##Local compilation of the files
If you want to get a preview of the website offline, you will need the following tools:
* the standard compiling tool "make";
* an OCaml installation;
* the Weberizer library, available through OPAM, a package manager for OCaml.

For Unix users, just install OCaml, and OPAM (available in the repository ppa:avsm/ppa); then, issue
    opam install weberizer
and compile the files using
		make

Windows users are kindly requested to install the same tools.

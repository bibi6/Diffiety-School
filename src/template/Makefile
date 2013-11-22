OCAMLFIND = $(shell which ocamlfind)

OCAMLC = $(OCAMLFIND) ocamlc
OCAMLOPT = $(OCAMLFIND) ocamlopt
OCAMLDEP = $(OCAMLFIND) ocamldep
PACKAGES = weberizer

PACKS = -package $(PACKAGES)
LINKPACKS = $(PACKS) -linkpkg

GENERATED_FILES = $(TEMPLATE_DIR)/diffiety.ml  $(TEMPLATE_DIR)/diffiety.mli

.SUFFIXES: .ml .mli .cmi .cmo .cma .cmx .cmxa

all: build.exe build.com

.depend.ocaml: $(wildcard *.ml) $(wildcard *.mli) diffiety.ml diffiety.mli
	@echo "Building $@ ... "
	-@test -z "$^" || $(OCAMLDEP) $^ > $@
# If we do not force inclusion (e.g. with "-" prefix), then it is not
# recreated and taken into account properly.
include .depend.ocaml

build.com: diffiety.cmx locations.cmx build.cmx
	$(OCAMLOPT) -o build.com $(LINKPACKS) $+

%.cmx: %.ml
	$(OCAMLOPT) $(PACKS) -c $<

build.exe: diffiety.cmo locations.cmo build.cmo
	 $(OCAMLC) -o build.exe $(LINKPACKS) $+

%.cmo: %.ml
	$(OCAMLC) $(PACKS) -c $<

%.cmi: %.mli
	$(OCAMLOPT) $(PACKS) -c $<

%.mli: %.ml
	-@test -f "$@" || \
  $(OCAMLC) $(PACKS) -c -i $< >$@

diffiety.ml diffiety.mli: diffiety.html
	weberizer diffiety.html


OCAMLFIND = $(shell which ocamlfind)

OCAMLC = $(OCAMLFIND) ocamlc
OCAMLOPT = $(OCAMLFIND) ocamlopt

PACKAGES = weberizer

PACKS = -package $(PACKAGES)
LINKPACKS = $(PACKS) -linkpkg

GENERATED_FILES = $(TEMPLATE_DIR)/diffiety.ml  $(TEMPLATE_DIR)/diffiety.mli

build.com: build.ml diffiety.cmx
	 $(OCAMLOPT) -o build.com $(LINKPACKS) diffiety.cmx build.ml

diffiety.cmx: diffiety.ml diffiety.cmi
	$(OCAMLOPT) -c $(PACKS) diffiety.ml

build.exe: build.ml diffiety.cmo
	 $(OCAMLC) -o build.exe $(LINKPACKS) diffiety.cmx build.ml

diffiety.cmo: diffiety.ml diffiety.cmi
	$(OCAMLC) -c $(PACKS) diffiety.ml

diffiety.cmi: diffiety.mli
	$(OCAMLOPT) -c $(PACKS) diffiety.mli
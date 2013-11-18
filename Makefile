.PHONY: web

TEMPLATE_DIR = src/template
BUILD_DIR = src/build

OCAMLFIND = $(shell which ocamlfind)

OCAMLC = $(OCAMLFIND) ocamlc
OCAMLOPT = $(OCAMLFIND) ocamlopt

PACKAGES = weberizer

PACKS = -package $(PACKAGES)
LINKPACKS = $(PACKS) -linkpkg

GENERATED_FILES = $(TEMPLATE_DIR)/diffiety.ml  $(TEMPLATE_DIR)/diffiety.mli

web: build
	if [ -x ./build.com ]; then ./build.com; else ./build.exe; fi

$(TEMPLATE_DIR)/diffiety.ml  $(TEMPLATE_DIR)/diffiety.mli : $(TEMPLATE_DIR)/diffiety.html
	cd $(TEMPLATE_DIR); weberizer diffiety.html

build: $(TEMPLATE_DIR)/build.ml $(TEMPLATE_DIR)/diffiety.cmx
	cd $(TEMPLATE_DIR); $(OCAMLOPT) -o build.com $(LINKPACKS) diffiety.cmx build.ml
	mv $(TEMPLATE_DIR)/build.com .

$(TEMPLATE_DIR)/diffiety.cmx: $(TEMPLATE_DIR)/diffiety.ml $(TEMPLATE_DIR)/diffiety.cmi
	cd $(TEMPLATE_DIR); $(OCAMLOPT) -c $(PACKS) diffiety.ml

$(TEMPLATE_DIR)/diffiety.cmi: $(TEMPLATE_DIR)/diffiety.mli
	cd $(TEMPLATE_DIR); $(OCAMLOPT) -c $(PACKS) diffiety.mli

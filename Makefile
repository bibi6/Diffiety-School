.PHONY: web

TEMPLATE_DIR = src/template
BUILD_DIR = src/build

web: build
	if [ -x ./build.com ]; then ./build.com; \
	else if [ -x ./build.exe ]; then ./build.exe;\
	else echo "No build executable: error!"; fi; fi

build: 
	make -C $(TEMPLATE_DIR);
	if [ -x $(TEMPLATE_DIR)/build.com ]; then  mv $(TEMPLATE_DIR)/build.com . ; fi
	if [ -x $(TEMPLATE_DIR)/build.exe ]; then  mv $(TEMPLATE_DIR)/build.exe . ; fi


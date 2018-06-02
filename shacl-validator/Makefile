SHACL_VERSION = 1.1.0
SHACL_DIR = shacl-${SHACL_VERSION}
SHACL_ZIP = shacl-${SHACL_VERSION}-bin.zip
SHACL_DOWNLOAD_URL = http://central.maven.org/maven2/org/topbraid/shacl/${SHACL_VERSION}/${SHACL_ZIP}

SHAPES = "demo-shapes.ttl"
DATA_VALID = "demo-valid-data.ttl"
DATA_INVALID = "demo-invalid-data.ttl"

RED = GREP_COLORS="sl=01;02;01;31:mt=01;00;01;31"
GREEN = GREP_COLORS="sl=01;02;01;32:mt=01;00;01;32"
GREP_VALIDATION = grep -A 3 -B 3 --color=always -e sh:conforms -e sh:resultMessage

help:
	@/bin/echo -e "\n\e[33m Available targets: \e[0m"
	@grep '^[-a-z]*:.*#' $(MAKEFILE_LIST) \
	  | sed -r 's/^([-a-z]*):.*# *(.*)/"\1:" "\2"/' \
	  | xargs printf '  - \e[1m%-12s\e[0m %s\n'
	@echo

prepare: mkexec # downloads, unzips and prepares the binary shacl version

clean: # removes all temporary files
	@if [ -d "$(SHACL_DIR)" ]; then rm -r "$(SHACL_DIR)"; fi
	@if [ -d "$(SHACL_ZIP)" ]; then rm "$(SHACL_ZIP)"; fi

${SHACL_ZIP}:
	curl ${SHACL_DOWNLOAD_URL} -L -o ${SHACL_ZIP}

${SHACL_DIR}: ${SHACL_ZIP}
	if [ -d "${SHACL_DIR}" ]; then rm -r "${SHACL_DIR}"; fi
	mkdir ${SHACL_DIR}
	unzip ${SHACL_ZIP}

mkexec: ${SHACL_DIR}
	chmod +x ${SHACL_DIR}/bin/*.sh

test: demo-valid demo-invalid

demo-valid: # show validation of a valid data file agains shape file
	@$(SHACL_DIR)/bin/shaclvalidate.sh -datafile $(DATA_VALID) -shapesfile $(SHAPES) 2> /dev/null \
	|$(GREEN) $(GREP_VALIDATION)
	
demo-invalid: # runs validation on a invalid test file downloaded from github
	@${SHACL_DIR}/bin/shaclvalidate.sh -datafile $(DATA_INVALID) -shapesfile $(SHAPES) 2> /dev/null \
	| $(RED) $(GREP_VALIDATION)

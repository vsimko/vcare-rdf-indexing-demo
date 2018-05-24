SHACL_VERSION=1.1.0
SHACL_DIR=shacl-${SHACL_VERSION}
SHACL_ZIP=shacl-${SHACL_VERSION}-bin.zip
SHACL_DOWNLOAD_URL=http://central.maven.org/maven2/org/topbraid/shacl/${SHACL_VERSION}/${SHACL_ZIP}

TESTFILE=${SHACL_DIR}/test.ttl

help:
	@echo
	@echo "Available targets:"
	@echo "  - prepare : downloads, unzips and prepares the binary shacl version"
	@echo "  - test    : runs validation on a test file downloaded from github"
	@echo "  - clean   : removes all temporary files"
	@echo

prepare: mkexec

clean:
	rm -r "${SHACL_DIR}"
	rm ${SHACL_ZIP}
	rm ${TESTFILE}

${SHACL_ZIP}:
	curl ${SHACL_DOWNLOAD_URL} -L -o ${SHACL_ZIP}

${SHACL_DIR}: ${SHACL_ZIP}
	if [ -d "${SHACL_DIR}" ]; then rm -r "${SHACL_DIR}"; fi
	mkdir ${SHACL_DIR}
	unzip ${SHACL_ZIP}

mkexec: ${SHACL_DIR}
	chmod +x ${SHACL_DIR}/bin/*.sh

test: ${TESTFILE}
	${SHACL_DIR}/bin/shaclvalidate.sh -datafile ${TESTFILE}

${TESTFILE}:
	curl https://raw.githubusercontent.com/TopQuadrant/shacl/master/src/test/resources/sh/tests/core/property/pattern-001.test.ttl -L -o ${TESTFILE}
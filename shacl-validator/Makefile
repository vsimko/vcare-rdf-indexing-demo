SHACL_VERSION=1.1.0
SHACL_DIR=shacl-${SHACL_VERSION}
SHACL_ZIP=shacl-${SHACL_VERSION}-bin.zip
SHACL_DOWNLOAD_URL=http://central.maven.org/maven2/org/topbraid/shacl/${SHACL_VERSION}/${SHACL_ZIP}

TESTFILE=${SHACL_DIR}/demonstrator.shapes.ttl
TESTFILE_BAD=${SHACL_DIR}/vcare.shapes.ttl

help:
	@echo
	@echo "Available targets:"
	@echo "  - prepare : downloads, unzips and prepares the binary shacl version"
	@echo "  - test    : runs validation on a test file downloaded from github"
	@echo "  - test2   : runs validation on a invalid test file downloaded from github"
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
	
test2: ${TESTFILE_BAD}
	${SHACL_DIR}/bin/shaclvalidate.sh -datafile ${TESTFILE_BAD}


${TESTFILE}:
	curl https://raw.githubusercontent.com/nmerkle/bilbao-demonstrator/master/initial-vcare-rdf/demonstrator.shapes.ttl?token=AI0yBq8N_zRknYi2PtYvLo17r-bNH4yqks5bD-0twA%3D%3D -L -o ${TESTFILE}

${TESTFILE_BAD}:
	curl https://raw.githubusercontent.com/vcare-project/vcare-models/master/vcare.shapes.ttl -L -o ${TESTFILE_BAD}

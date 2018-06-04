#!/bin/bash

function finish {
    echo cleanup...
    pkill -e node
    exit 1
}
trap finish EXIT SIGINT SIGTERM

# helper function
INFO() {
    echo
    echo -e "\e[93m$@\e[39m"
}

WAIT_USER_INPUT() {
    echo -e "\e[1m\e[96m\e[5m"
    printf "%0$(tput cols)d"|tr 0 _
    if [ $# -gt 0 ]; then
        echo "$@"
    fi
    echo "Press ENTER to continue..."
    echo -e "\e[0m"
    read
}

wait200() {
    URL="$1"
    echo -n -e "Waiting for \e[93m$URL\e[39m ..."
    while ! curl -f -s -w ''%{http_code}'' -o /dev/null "$URL" >/dev/null; do
        echo -n '.'
        sleep 1
    done
    echo -e "\e[32m done \e[39m"
}

wait_blaze_ns() {
    NS="$1"
    wait200 "http://localhost:8889/bigdata/namespace/$NS/properties"
}

wait_solr_core() {
    CORE="$1"
    wait200 "http://localhost:8983/solr/$CORE/admin/ping"
}

# our script begins here
if [ -z $NO_CLEAN ]; then
    INFO "Cleanup and prepare first..."
    make -C shacl-validator clean prepare
    make -C docker clean prepare
fi

INFO "Starting Docker containers ..."
make -C docker start

INFO "The following docker services are now running:"
make -C docker ps

INFO "Creating cores in Solr used by RDF store and Timeline API ..."
wait200 "http://localhost:8983/solr/"
(
    make -C docker solrcores
)

INFO "Waiting for Solr core to appear online ..."
wait_solr_core "knowledgegraph"
wait_solr_core "timelines"

INFO "Validating SHACL Schema against \e[1mvalid\e[0m data file..."
make -C shacl-validator demo-valid
WAIT_USER_INPUT

INFO "Validating SHACL Schema against invalid data file..."
make -C shacl-validator demo-invalid
WAIT_USER_INPUT

INFO "Importing sample data to Blazegraph"
wait_blaze_ns "kb"
(
    cd initial-vcare-rdf
    ./blazegraph-import.sh demonstrator.shapes.ttl
)
WAIT_USER_INPUT

INFO "Indexing RDF data in Solr core 'knowledgegraph' ..."
(
    cd demo-indexer
    yarn
    yarn start
)

INFO "Starting Timeline API ..."
(
    cd timeline-api
    yarn
    yarn start &
) > /dev/null

INFO "Starting demo-event-logger ..."
(
    cd mqtt-demo-eventlogger
    yarn
    yarn start &
) > /dev/null

INFO "Starting demo-data-generator ..."
(
    cd mqtt-demo-publisher
    yarn
    yarn start &
) > /dev/null

echo
INFO "All components are now ready:"
echo -e " -\e[1m Timeline API: \e[0m http://localhost:4000"
echo -e " -\e[1m Solr:         \e[0m http://localhost:8983/solr/"
echo -e " -\e[1m Blazegraph:   \e[0m http://localhost:8889/bigdata/"
echo

WAIT_USER_INPUT "Now, we are going to kill all running 'node' instances"

# Start Demo Query (Timeline)
#echo "---Making Timeline Query.---"
#cd ../demo-timeline-query
#sudo ./run.sh
# Start Demo Query (Indexed Data)
#echo "----Making GraphData query----"
#cd ../demo-idxdata-query
#sudo ./run.sh

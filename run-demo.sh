#!/bin/bash

function finish {
    echo cleanup...
    pkill -e node
    exit 1
}
trap finish EXIT SIGINT SIGTERM

# helper function
INFO() {
    echo -e "\e[93m$@\e[39m"
}

# helper function
waitport() {
    PORT="$1"
    NAME="$2"
    echo -n -e "Waiting for \e[93m$NAME\e[39m on port \e[93m$PORT\e[39m ..."

    while ! timeout 1 echo 2>/dev/null > /dev/tcp/localhost/$PORT; do
        echo -n '.'
        sleep 0.4
    done

    echo -e "\e[32m done \e[39m"
}

# helper function
waitnamespace() {
    NS="$1"
    echo -n -e "Waiting for namespace \e[93m$NS\e[39m in Blazegraph ..."
    while ! curl -f -s -w ''%{http_code}'' -o /dev/null "http://localhost:8889/bigdata/namespace/$NS/properties" >/dev/null; do
        echo -n '.'
        sleep 1
    done
    echo -e "\e[32m done \e[39m"
}

# our script begins here

INFO "Cleanup and prepare first..."
make -C docker clean prepare
make -C shacl-validator clean prepare

INFO "Starting Docker containers ..."
make -C docker start

INFO "The following docker services are now running:"
make -C docker ps

waitport 8983 Solr && (
    INFO "Creating cores in Solr used by RDF store and Timeline API ..."
    make -C docker solrcores
)

INFO "Validating SHACL Schema against \e[1mvalid\e[0m data file..."
make -C shacl-validator demo-valid

INFO "Validating SHACL Schema against invalid data file..."
make -C shacl-validator demo-invalid

waitport 8889 Blazegraph && waitnamespace kb && (
    cd initial-vcare-rdf
    INFO "Importing sample data to Blazegraph"
    ./blazegraph-import.sh demonstrator.shapes.ttl
)

# # # Demo-Indexer - Start Demo-Indexer in order to index GraphDB instances
# # echo "Indexing now the GraphDB data in knowledgegraph core in Solr"
# # cd ../demo-indexer/graphdb-indexer
# # sudo mvn exec:java # -Dexec .mainClass="de.fzi.ipe.wim.vcare.demo.indexer.Indexer"

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

INFO "Press ENTER to kill running instances"
read
exit

# Start Demo Query (Timeline)
#echo "---Making Timeline Query.---"
#cd ../demo-timeline-query
#sudo ./run.sh
# Start Demo Query (Indexed Data)
#echo "----Making GraphData query----"
#cd ../demo-idxdata-query
#sudo ./run.sh

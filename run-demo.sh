#!/bin/bash

echo_yellow() {
    echo -e "\e[93m$@\e[39m"
}

waitport() {
    PORT="$1"
    NAME="$2"
    echo -n -e "Waiting for \e[93m$NAME\e[39m on port \e[93m$PORT\e[39m"

    while ! timeout 1 echo 2>/dev/null > /dev/tcp/localhost/$PORT; do
        echo -n '.'
        sleep 0.4
    done

    echo -e "\e[32m done \e[39m"
}

echo_yellow "Starting GraphDB ..."
(
    cd graphdb-free/bin
    ./graphdb &
)

echo_yellow "Starting MQTT and SOLR! ..."
make -C docker prepare start

echo_yellow "The following docker services are now running:"
make -C docker ps

waitport 8983 Solr

echo_yellow "Creating cores in Solr used for GraphDB and Timeline API"
make -C docker solrcores

echo_yellow "Validating SHACL Schema:"
(
    cd shacl-validator
    make prepare

    echo
    echo_yellow "Validating SHACL Schema against valid data file..."
    make demo-valid

    echo
    echo_yellow "Validating SHACL Schema against invalid data file..."
    make demo-invalid
)

cd ../initial-vcare-rdf
echo "Now we import the valid SHACL Schema into GraphDB"
sudo chmod +x graphdb-create-vcare-repo.sh
sudo chmod +x graphdb-import-shacl-schema.sh
./graphdb-create-vcare-repo.sh
./graphdb-import-shacl-schema.sh

# Demo-Indexer - Start Demo-Indexer in order to index GraphDB instances
echo "Indexing now the GraphDB data in knowledgegraph core in Solr"
cd ../demo-indexer/graphdb-indexer
sudo mvn exec:java # -Dexec .mainClass="de.fzi.ipe.wim.vcare.demo.indexer.Indexer"
# Start Timeline Abstraction
echo "Starting timeline-api."
cd ../../timeline-api
sudo yarn
#sudo yarn start
sudo nohup node ./index.js &
# Start Demo Event Logger
echo "Starting demo-event-logger"
cd ../mqtt-demo-eventlogger
sudo yarn
sudo nohup node ./index.js &
#sudo yarn start
# Start Demo Data Generator
echo "Starting demo-data-generator"
cd ../mqtt-demo-publisher
sudo yarn
sudo nohup node ./index.js &
#sudo yarn start
# Start Demo Query (Timeline)
#echo "---Making Timeline Query.---"
#cd ../demo-timeline-query
#sudo ./run.sh
# Start Demo Query (Indexed Data)
#echo "----Making GraphData query----"
#cd ../demo-idxdata-query
#sudo ./run.sh

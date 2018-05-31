#!/bin/bash
cd graphdb-free/bin
./graphdb &

cd ../../docker
echo "Starting MQTT, GraphDB and SOLR!"
sudo make prepare
sudo make start
sudo make ps
#wait  5
echo "Creating a GraphDB Core in Solr"
sudo make create

echo "Validating SHACL Schema"
cd ../shacl-validator
echo "First we validate a valid and conform SHACL Schema"
make prepare
make test
#echo "Now we validate an invalid SHACL Schema"
#make test2
#make clean

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
echo "---Making Timeline Query.---"
cd ../demo-timeline-query
sudo ./run.sh
# Start Demo Query (Indexed Data)
echo "----Making GraphData query----"
cd ../demo-idxdata-query
sudo ./run.sh

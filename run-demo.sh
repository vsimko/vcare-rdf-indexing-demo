#!/bin/bash
cd graphdb-free/bin
./graphdb &

cd ../../docker
echo "Starting MQTT, GraphDB and SOLR!"
sudo make prepare
sudo make start
sudo make ps
wait  5
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

# TODO: Demo-Indexer - Start Demo-Indexer in order to index GraphDB instances
echo "Indexing now the GraphDB data in knowledgegraph core in Solr"
cd ../demo-indexer/graphdb-indexer
sudo mvn exec:java # -Dexec .mainClass="de.fzi.ipe.wim.vcare.demo.indexer.Indexer"
# TODO: Start Timeline Abstraction
# TODO: Start Demo Event Logger
# TODO: Start Demo Data Generator

# TODO: Start Demo Query (Timeline)
# TODO: Start Demo Query (Indexed Data)

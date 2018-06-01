help:
	@echo
	@echo "Available targets: $%"
	@grep '^[a-z]*:.*#' $(MAKEFILE_LIST) \
	  | sed -r 's/^([[:alpha:]]*):.*# *(.*)/"\1:" "\2"/' \
	  | xargs printf '  - %-12s %s\n'
	@echo

prepare: # create all dirs
	mkdir -p graphdb-home
	mkdir -p solr-data
	chmod 777 solr-data

clean: down # remove all dirs (requires root password)
	sudo rm -r graphdb-home/
	sudo rm -r solr-data/

up: start
start: # start all docker containers
	docker-compose up -d

down: # stop and remove all docker containers
	docker-compose down

ps: # show all running containers
	docker-compose ps

create: solrcores
solrcores: # create solr cores for our demo
	docker-compose exec solr /opt/solr/bin/solr create_core -c knowledgegraph
	docker-compose exec solr /opt/solr/bin/solr create_core -c timelines

solrshell: # open root shell in the running solr container
	docker-compose exec -u root solr bash

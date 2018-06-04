help:
	@/bin/echo -e "\n\e[33m Available targets: \e[0m"
	@grep '^[-a-z]*:.*#' $(MAKEFILE_LIST) \
	  | sed -r 's/^([-a-z]*):.*# *(.*)/"\1:" "\2"/' \
	  | xargs printf '  - \e[1m%-12s\e[0m %s\n'
	@echo


prepare: # create all dirs
	mkdir -p blaze-data
	mkdir -p solr-data
	chmod 777 solr-data

clean: down # remove all dirs (requires root password)
	sudo rm -r blaze-data/
	sudo rm -r solr-data/

up: start
start: # start all docker containers
	@docker-compose up -d

down: # stop and remove all docker containers
	@docker-compose down

ps: # show all running containers
	@docker-compose ps

create: solrcores
solrcores: # create solr cores for our demo
	docker-compose exec solr /opt/solr/bin/solr create_core -c knowledgegraph
	docker-compose exec solr /opt/solr/bin/solr create_core -c timelines

solrshell: # open root shell in the running solr container
	docker-compose exec -u root solr bash

blazeshell: # open root shell in the running blazegraph container
	docker-compose exec -u root blaze sh

br-solr: # open Solr web interface in a browser
	browse http://localhost:8983/solr

br-blaze: # open Blzegraph web interface in a browser
	browse http://localhost:8889/bigdata

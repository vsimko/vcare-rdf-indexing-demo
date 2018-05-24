help:
	@echo
	@echo "Available targets"
	@echo "  - prepare: create all dirs"
	@echo "  - start:   start all docker containers"
	@echo "  - down:    stop and remove all docker containers"
	@echo "  - ps:      show all running containers"
	@echo "  - clean:   remove all dirs"
	@echo

prepare:
	mkdir -p graphdb-home
	mkdir -p solr-data
	chmod 777 solr-data

clean:
	sudo rm -r graphdb-home/
	sudo rm -r solr-data/

up: start
start:
	docker-compose up -d

down:
	docker-compose down

ps:
	docker-compose ps

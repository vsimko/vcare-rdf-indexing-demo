# bilbao-demonstrator

## Running docker containers
```console
$ cd docker
$ docker-compose up -d
```

You can check that all the docker containers are running:
```console
$ docker-compose ps
```

The output should contain something like this:
```
IMAGE                       PORTS                    NAMES          ...
solr:alpine                 0.0.0.0:8983->8983/tcp   vcare-solr     ...
eclipse-mosquitto:latest    0.0.0.0:1883->1883/tcp   vcare-mqtt     ...
ontotext/graphdb:8.0.4-se   0.0.0.0:7200->7200/tcp   vcare-graphdb  ...
```

## Demo Overview

![](https://docs.google.com/drawings/d/e/2PACX-1vQYE20zYvSbpYUsRmlE70WIobPoB072BQyqtr_wXwppngGyG7UlzlIWGAHPVG0IXZdpVF8m35eYsZCQ/pub?w=907&h=899)

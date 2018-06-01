# TL;DR

```console
$ git clone --depth 1 https://github.com/nmerkle/bilbao-demonstrator.git
$ cd bilbao-demonstrator
$ ./run-demo.sh
```

# Cleanup
```console
$ cd docker
$ docker-compose down
```
... after that, you can safely remove the whole `bilbao-demonstrator`.

# Prerequisites
- internet connection
- docker v17.05
- docker-compose v1.16
- node v8.11.2
- yarn (npm package installed globally using `npm install -g yarn`) v1.7
- GNU bash v4.3
- GNU make v4.1
- pkill
- curl v7.47
- unzip v6.0

# Running docker containers only

```console
$ cd docker
$ make start
```
Then you can check that all containers are running
```console
$ make ps
```

# Running SHACL validation demo only

```console
$ cd shacl-validation
$ make clean prepare
$ make demo-valid
$ make demo-invalid
```

# Importing data to Blazegraph
```console
$ cd initial-vcare-rdf
$ ./blazegraph-import.sh path/to/file.ttl
```

## Demo Overview
![](https://docs.google.com/drawings/d/e/2PACX-1vQYE20zYvSbpYUsRmlE70WIobPoB072BQyqtr_wXwppngGyG7UlzlIWGAHPVG0IXZdpVF8m35eYsZCQ/pub?w=907&h=899)

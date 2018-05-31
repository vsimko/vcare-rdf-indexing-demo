#!/bin/bash

cd docker

sudo make down
sudo make clean
sudo kill -9 $(ps -A | pgrep java )

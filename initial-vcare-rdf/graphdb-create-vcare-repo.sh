#!/bin/sh

curl \
  -X POST --header 'Content-Type:multipart/form-data' \
  --header 'Accept:*/*' \
  -F config=@vcare-config.ttl \
  'http://localhost:7200/rest/repositories'

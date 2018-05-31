#!/bin/bash

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
   "data": "http://localhost/demonstrator.shapes.ttl",
   "name": "demonstrator.shapes.ttl",
   "forceSerial": true,
   "parserSettings": {
     "failOnUnknownDataTypes": true,
     "failOnUnknownLanguageTags": true,
     "normalizeDataTypeValues": true,
     "normalizeLanguageTags": true,
     "preserveBNodeIds": true,
     "stopOnError": true,
     "verifyDataTypeValues": true,
     "verifyLanguageTags": true,
     "verifyRelativeURIs": true,
     "verifyURISyntax": true
   },
   "status": "DONE",
   "timestamp": 0
 }' 'http://localhost:7200/rest/data/import/upload/vcare/url'

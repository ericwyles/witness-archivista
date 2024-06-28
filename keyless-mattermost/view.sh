#!/bin/bash

#curl http://localhost:8082/download/$1 | jq -r '.payload' | base64 -d | jq
curl https://archivista.testifysec.io/download/$1 | jq -r '.payload' | base64 -d | jq
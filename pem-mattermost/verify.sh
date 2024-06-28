#!/bin/bash

#verify the attestations
witness verify -k target/policypublic.pem -p target/policy.signed.json --enable-archivista -f $1 

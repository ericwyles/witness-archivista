#!/bin/bash

mkdir target

#generate key pair for signing attestations
openssl genrsa -out target/buildkey.pem 2048
openssl rsa -in target/buildkey.pem -outform PEM -pubout -out target/buildpublic.pem

curl -L https://github.com/defenseunicorns/uds-package-mattermost/archive/refs/tags/v9.9.0-uds.0.tar.gz -o target/mattermost.tgz
tar zxvf target/mattermost.tgz -C target

#run a "build" and create signed attestation and store in archivista
cd target/uds-package-mattermost-9.9.0-uds.0  && witness run -s build -a slsa -k ../../target/buildkey.pem --enable-archivista -- bash -c "uds run create-mm-test-bundle"
cd -

#template the policy
./template_policy.sh

#generate a key pair for signing the policy
openssl genrsa -out target/policykey.pem 2048
openssl rsa -in target/policykey.pem -outform PEM -pubout -out target/policypublic.pem


#sign the policy
witness sign -k target/policykey.pem -f target/policy.json -o target/policy.signed.json


#verify the attestations
./verify.sh target/uds-package-mattermost-9.9.0-uds.0/zarf-package-mattermost-amd64-9.9.0-uds.0.tar.zst

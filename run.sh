#!/bin/bash

#generate key pair for signing attestations
openssl genrsa -out buildkey.pem 2048
openssl rsa -in buildkey.pem -outform PEM -pubout -out buildpublic.pem

#run a "build" and create signed attestation
witness run -s build -a environment -k buildkey.pem -o build-attestation.json -- bash -c "echo 'hello' > hello.txt"

#view the attestation
cat build-attestation.json | jq -r .payload | base64 -d | jq .

#template the policy
./template_policy.sh

#generate a key pair for signing the policy
openssl genrsa -out policykey.pem 2048
openssl rsa -in policykey.pem -outform PEM -pubout -out policypublic.pem

#sign the policy
witness sign -k policykey.pem -f policy.json -o policy.signed.json

#verify the attestations
witness verify -k policypublic.pem -p policy.signed.json -a build-attestation.json -f hello.txt


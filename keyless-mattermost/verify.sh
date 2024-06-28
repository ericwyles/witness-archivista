#!/bin/bash

#verify the attestations
witness verify \
    -p target/policy.signed.json \
    --policy-ca-roots target/fulcio-root.pem \
    --policy-ca-intermediates target/fulcio-int.pem \
    --policy-timestamp-servers target/freetsa.pem \
    --enable-archivista \
    -f $1

#!/bin/bash
rm -rf target
mkdir target

curl -L https://github.com/defenseunicorns/uds-package-mattermost/archive/refs/tags/v9.9.0-uds.0.tar.gz -o target/mattermost.tgz
tar zxvf target/mattermost.tgz -C target

#run a "build" and create signed attestation and store in archivista
cd target/uds-package-mattermost-9.9.0-uds.0  && \
    witness run -s build \
                --enable-archivista \
                -a slsa \
                --signer-fulcio-url https://fulcio.sigstore.dev \
                --signer-fulcio-oidc-client-id sigstore \
                --signer-fulcio-oidc-issuer https://oauth2.sigstore.dev/auth \
                --timestamp-servers https://freetsa.org/tsr \
                -- bash -c "uds run create-mm-test-bundle"
cd -


#get the Fulcio root bundle
curl -s https://fulcio.sigstore.dev/api/v2/trustBundle > target/fulcio.pem
cat target/fulcio.pem | jq -r '.chains[0].certificates[0]' > target/fulcio-root.pem
cat target/fulcio.pem | jq -r '.chains[0].certificates[1]' > target/fulcio-int.pem

#get the FreeTSA root ca
curl -s https://freetsa.org/files/cacert.pem > target/freetsa.pem


#template the policy
./template_policy.sh

#sign the policy
witness sign \
        --signer-fulcio-url https://fulcio.sigstore.dev \
        --signer-fulcio-oidc-client-id sigstore \
        --signer-fulcio-oidc-issuer https://oauth2.sigstore.dev/auth \
        --timestamp-servers https://freetsa.org/tsr \
        -f target/policy.json \
        -o target/policy.signed.json

#verify the attestations
./verify.sh target/uds-package-mattermost-9.9.0-uds.0/zarf-package-mattermost-amd64-9.9.0-uds.0.tar.zst

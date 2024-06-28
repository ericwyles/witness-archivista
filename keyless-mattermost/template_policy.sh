#!/bin/bash
#requires yq v4.2.0
email="$1"
fulcio_root="$(cat target/fulcio.pem | jq -r '.chains[0].certificates[0]')"
fulcio_int="$(cat target/fulcio.pem | jq -r '.chains[0].certificates[1]')"
freetsa_root="$(cat target/freetsa.pem)"
fulcio_root_b64="$(echo "$fulcio_root" | openssl base64 -A)"
fulcio_int_b64="$(echo "$fulcio_int" | openssl base64 -A)"
freetsa_root_b64="$(echo "$freetsa_root" | openssl base64 -A)"

cmd_b64="$(openssl base64 -A <"cmd.rego")"
cp policy-template.yaml target/policy.tmp.yaml

# Use double quotes around variables in sed commands to preserve newlines
sed -i "s|{{FULCIO_ROOT}}|$fulcio_root_b64|g" target/policy.tmp.yaml
sed -i "s|{{FULCIO_INT}}|$fulcio_int_b64|g" target/policy.tmp.yaml
sed -i "s|{{FREETSA_ROOT}}|$freetsa_root_b64|g" target/policy.tmp.yaml
sed -i "s|{{EMAIL}}|$email|g" target/policy.tmp.yaml
sed -i "s|{{CMD_MODULE}}|$cmd_b64|g" target/policy.tmp.yaml

yq e -j target/policy.tmp.yaml > target/policy.json

# Calculate SHA256 hash (macOS and Linux compatible)
if [[ "$(uname)" == "Darwin" ]]; then
	fulcio_keyid="$(echo -n "$fulcio_root" | shasum -a 256 | awk '{print $1}')"
	sed -i "s|{{FULCIO_KEYID}}|$fulcio_keyid|g" target/policy.json
else
	fulcio_keyid="$(echo -n "$fulcio_root" | sha256sum | awk '{print $1}')"
	sed -i "s|{{FULCIO_KEYID}}|$fulcio_keyid|g" target/policy.json
fi

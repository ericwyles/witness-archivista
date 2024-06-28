#/bin/sh
#requires yq v4.2.0
cmd_b64="$(openssl base64 -A <"cmd.rego")"
pubkey_b64="$(openssl base64 -A <"target/buildpublic.pem")"
cp policy-template.yaml target/policy.tmp.yaml
keyid=`sha256sum target/buildpublic.pem | awk '{print $1}'`
sed -i "s/{{KEYID}}/$keyid/g" target/policy.tmp.yaml
yq eval ".publickeys.${keyid}.key = \"${pubkey_b64}\"" --inplace target/policy.tmp.yaml
sed -i "s/{{CMD_MODULE}}/$cmd_b64/g" target/policy.tmp.yaml
yq e -j target/policy.tmp.yaml > target/policy.json


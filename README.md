# Prerequisites

```
brew install yq
brew install shasum
brew install jq
brew install openssl
brew install wget
brew install witness
```

# build, attest, verify
`./run.sh`

This will...
* generate keys for building
* generate keys for policy signing
* download uds-package-mattermost source code and extract it
* run a build using witness with the slsa attestor and the build keys. the attestations will be stored in the public archivista instance
* template the policy file using the generated keys and the cmd.rego
* verify attestations for target/uds-package-mattermost-9.9.0-uds.0/zarf-package-mattermost-amd64-9.9.0-uds.0.tar.zst


# view the attestations
`./view.sh <shasum>`

where <shasum> is printed in the log message near the end of run.sh

`INFO    Stored in archivista as fcf86d0804d3ed5b4e9da9994414b0804f9600c58e4b1cf25ae43b9044692d4f`

# verify attestations for an arbitrary file
`./verify.sh <fileName>`

Examples: 
* `./verify.sh target/uds-package-mattermost-9.9.0-uds.0/zarf-package-dev-namespace-amd64-0.1.0.tar.zst`
* `./verify.sh target/uds-package-mattermost-9.9.0-uds.0/bundle/uds-bundle-mattermost-test-amd64-9.9.0-uds.0.tar.zst`

This will work for any file that was generated in the cwd (`target/uds-package-mattermost-9.9.0-uds.0`) or any subdir as part of the build.

# clean up
`./clean.sh`

Deletes the target directory where everything is stored

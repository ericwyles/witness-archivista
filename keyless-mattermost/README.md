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
* download uds-package-mattermost source code and extract it
* run a build using witness with the slsa attestor
    * the attestations will be stored in the public archivista instance
    * sigstore is used for signing the attestations
* download root ca bundle for fulcio
* download root ca for free tsa
* template the policy file using the downloaded keys and the cmd.rego
* verify attestations for the zarf package `target/uds-package-mattermost-9.9.0-uds.0/zarf-package-mattermost-amd64-9.9.0-uds.0.tar.zst`
    * attestations are retrieved from archivista
    * the signed policy from the target directory is used to verify the command that was executed to build mattermost

TIP: If you want to see the policy verification fail, you can change the line `-- bash -c "uds run create-mm-test-bundle"` in run.sh to `-- bash -c "uds run create-mm-package"` -- this will still build the mattermost package using a different command and the artifact will fail policy validation

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

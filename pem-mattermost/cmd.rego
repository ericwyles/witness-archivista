package commandrun

deny[msg] {
    input.exitcode != 0
    msg := "exitcode not 0"
}

deny[msg] {
    input.cmd[2] != "uds run create-mm-test-bundle"
    msg := "cmd not correct"
}

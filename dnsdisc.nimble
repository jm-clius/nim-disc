# Package

packageName   = "dnsdisc"
version       = "0.1.0"
author        = "Status Research & Development GmbH"
description   = "Nim discovery library supporting EIP-1459"
license       = "MIT or Apache License 2.0"

# Dependencies

requires "nim >= 1.6.0",
  "bearssl",
  "chronicles",
  "chronos",
  "eth",
  "secp256k1",
  "stew",
  "testutils",
  "unittest2",
  "nimcrypto",
  "results"

# Helper functions
proc buildBinary(name: string, srcDir = "./", params = "", lang = "c") =
  if not dirExists "build":
    mkDir "build"
  # allow something like "nim nimbus --verbosity:0 --hints:off nimbus.nims"
  var extra_params = params
  for i in 2..<paramCount():
    extra_params &= " " & paramStr(i)
  exec "nim " & lang & " --mm:refc --out:build/" & name & " " & extra_params & " " & srcDir & name & ".nim"
  if NimMajor >= 2:
    exec "nim " & lang & " --mm:orc --out:build/" & name & " " & extra_params & " " & srcDir & name & ".nim"

proc test(name: string, params = "-d:chronicles_log_level=DEBUG", lang = "c") =
  # XXX: When running `> NIM_PARAMS="-d:chronicles_log_level=INFO" make test2`
  # I expect compiler flag to be overridden, however it stays with whatever is
  # specified here.
  exec "nim " & lang & " --mm:refc -r " & params & " tests/" & name & ".nim"
  if NimMajor >= 2:
    exec "nim " & lang & " --mm:orc -r " & params & " tests/" & name & ".nim"

task creator, "Build DNS discovery tree creator":
  buildBinary "tree_creator", "dnsdisc/creator/", "-d:chronicles_log_level=DEBUG -d:chronosStrictException"

task test, "Build & run all DNS discovery tests":
  test "all_tests"

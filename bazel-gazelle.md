# bazel gazelle

## Troubleshooting

### Proto dependencies aren't being created

Resolve warnings for multiple rules, eg:

> INFO: Running command line: bazel-bin/gazelle
> gazelle: rule //lib imports "fizz/proto" which matches multiple rules: //proto:options and //> proto:proto_go_proto. # gazelle:resolve may be used to disambiguate
> gazelle: rule //modelchecker imports "fizz/proto" which matches multiple rules: //proto:options and //proto:proto_go_proto. # gazelle:resolve may be used to disambiguate
> gazelle: rule //modelchecker:modelchecker_test imports "fizz/proto" which matches multiple rules: //proto:options and //proto:proto_go_proto. # gazelle:resolve may be used to disambiguate
> gazelle: rule //:fizzbee_lib imports "fizz/proto" which matches multiple rules: //proto:options and //proto:proto_go_proto. # gazelle:resolve may be used to disambiguate

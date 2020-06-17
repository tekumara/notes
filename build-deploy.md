# build deploy 

## requirements

1. Each step runs inside a docker container
1. Steps are specified in small Makefiles/scripts 
1. Check, test, and build steps can be run from a developer laptop
1. Deploy steps can be run from a developer laptop
1. Docker containers can be built
1. IAM roles are assumed by the CI system/developer rather than baked into steps
1. Secrets are provided by the CI system/developer rather than baked into steps
1. The packaged application runs in the same environment as tests
1. Medium-sized tests (ie: tests that span multiple processes/containers) can be run
1. The CI system caches steps and only runs steps that have changes
1. Common steps can be reused across repos
1. UI to see the CI logs
1. Notifications of success/failure
1. Steps can be blocks that require manual intervention
1. Steps can be expressed in YAML rather than a general-purpose language
1. Pipelines can run on a schedule

## pipeline

Assumes green/blue deployment (is this reasonable for CF/k8s?)  
Q: where do medium-sized tests go?

1. check-test
    1. check (linter, static type analyse)
    1. test

1. build
    1. build docker container
    1. push container

1. !master branch deploy
    1. deploy to test
    1. smoke test
    1. flip

1. master branch deploy
    1. deploy to prod
    1. smoke test
    1. flip
    1. notifications - slack, new relic release events
    1. publish to corp catalogue



#!/bin/sh -l

set -e
set -x

TEST_SUITE_NAME=$1

echo "Running TestSuite: ${TEST_SUITE_NAME}"
time=$(date)
# echo "::set-output name=time::$time"

aws eks update-kubeconfig --name ops

kubectl version

kubectl get pods -A

kubectl testkube run testsuite ${TEST_SUITE_NAME} -f

# Get last test status
LAST_TEST_STATUS=$(kubectl testkube get testsuiteexecution -o json | jq -r '.results[0].status')

if [[ "${LAST_TEST_STATUS}" == "error" ]]; then
    exit(1)
else
    exit(0)
fi

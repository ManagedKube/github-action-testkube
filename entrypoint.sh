#!/bin/bash

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
LAST_TEST_EXECUTION_LIST=$(kubectl testkube get testsuiteexecution -o json | jq -r '.results[0].execution')

if [[ "${LAST_TEST_STATUS}" == "error" ]]; then
    # Error, output errors

    # Loop through the last result's "execution" list to get the execution ID so that we can output the 
    # detailed info on that run
    # [
    #     {
    #         "id": "623b335bf888277eb479668c",
    #         "name": "run:testkube/infra-base-prometheus-endpoint",
    #         "status": "success",
    #         "type": "executeTest"
    #     },
    #     {
    #         "id": "623b335ff888277eb479668e",
    #         "name": "run:testkube/infra-base-alertmanager-slack-config",
    #         "status": "error",
    #         "type": "executeTest"
    #     }
    # ]
    for row in $(echo "${LAST_TEST_EXECUTION_LIST}" | jq -r '.[] | @base64'); do
        _jq() {
            echo ${row} | base64 -d | jq -r ${1}
        }
        EXECUTION_STATUS=$(_jq '.status')

        if [[ "${EXECUTION_STATUS}" == "error" ]]; then
            # Output the details of the testkube run

            EXECUTION_ID=$(_jq '.id')

            kubectl testkube get execution ${EXECUTION_ID}
        fi

    done

    exit 1
else
    # Success
    exit 0
fi

#!/bin/sh -l

set -e
set -x

TEST_SUITE_NAME=$1

echo "Hello ${TEST_SUITE_NAME}"
time=$(date)
echo "::set-output name=time::$time"

aws eks update-kubeconfig --name ops

kubectl version

kubectl get pods -A

kubectl testkube run testsuite ${TEST_SUITE_NAME} -f

#!/bin/sh -l

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"

aws eks update-kubeconfig --name ops

kubectl version

kubectl get pods -A

ls -l

ls -l ./test/testkube/infra

kubectl testkube run testsuite ./test/testkube/infra -f

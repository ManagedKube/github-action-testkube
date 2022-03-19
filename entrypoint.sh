#!/bin/sh -l

set -e

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"

aws eks update-kubeconfig --name ops

kubectl version

kubectl get pods -A

kubectl testkube run testsuite infra -f

#!/bin/bash -e

lpass status || { echo "Log in to lastpass."; exit 1; }

fly -t ci set-pipeline -p blorg -c .ci/pipeline.yml \
  -v "dockerhub-password=$(lpass show --password docker.com)" \
  -v "deploy-key=$(lpass show blorg-deploy-key --field='Private Key')"


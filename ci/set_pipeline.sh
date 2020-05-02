#!/bin/bash -e

fly -t devbox set-pipeline -p blorg -c ci/pipeline.yml \
  -v "dockerhub-password=$(lpass show --password docker.com)" \
  -v "deploy-key=$(lpass show blorg-deploy-key --field='Private Key')"


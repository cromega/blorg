#!/bin/bash -e

fly -t devbox set-pipeline -p blorg -c ci/pipeline.yml \
  -v "dockerhub-password=$(lpass show --password docker.com)" \
  -v "deploy-key=$(lpass show blorg-deploy-key --field='Private Key')" \
  -v "ci-access-key-id=$(lpass show ci-user-access-key --field=access-key-id)" \
  -v "ci-secret-access-key=$(lpass show ci-user-access-key --field=secret-access-key)"


#!/bin/bash -e

fly -t local set-pipeline -p blorg -c ci/pipeline.yml \
  -v "blorg-deploy-key=$(cat ../sublimia-platform/secrets/deploy_key)" \
  -v "deployer-private-key=$(cat ../sublimia-platform/secrets/id_rsa)" \
  -v "dockerhub-password=$(lpass show --password docker.com)"


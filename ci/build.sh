#!/bin/bash -e

apt-get update
apt-get -y install build-essential git

cd blog
bundle install --without=test
bundle exec jekyll build

cp -r . ../blog-rendered/

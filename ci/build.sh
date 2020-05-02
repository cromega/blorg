#!/bin/bash -e

cd blog
bundle exec jekyll build

cp -r _site ../build-output/
cp nginx.conf ../build-output/
cp Dockerfile ../build-output/

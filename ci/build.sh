#!/bin/bash -e

cd blog
bundle exec jekyll build

cp -r . ../build-output/

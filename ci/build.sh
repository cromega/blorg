#!/bin/bash -e

bundle exec jekyll build

cp -r . ../blog-rendered/

#!/bin/bash -e

title=$1
slug="$(echo $title | tr '[A-Z]' '[a-z]' | tr ' ' '-')"
fn="$(date +%Y-%m-%d)-${slug}.md"

echo -n "---
author: cromega
layout: json
title: ${title}
date: $(date -u)
permalink: /posts/${slug}/
tags: [ADD, TAGS]
category: dev
---" > "_drafts/${fn}"

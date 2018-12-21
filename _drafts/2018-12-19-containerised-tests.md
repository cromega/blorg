---
author: cromega
layout: json
title: containerised tests
date: Wed Dec 19 17:13:32 UTC 2018
permalink: /posts/containerised-tests/
tags: [geek]
category: dev
---

I know that mocking is good, mocking is great but at the same time mocking also sucks so I try not to overdo it. If something doesn't take a long time (eg: writing a file), I usually don't mock it. In ruby it's easy to stub `File.write` but then your test is tied to an implementation detail and it will break as soon as you change it to `puts` and it's not nearly as easy to do in other programming languages.

Long story short, If my the purpose (or, god forbid, side effect) of my class is writing a file, I want to test that very behaviour.

Files, however, represent state. I started running my test suites that generate a state in a container.

<!-- more -->

Running rspec in a container is nothing tricky but I quickly got tired of having to run bundle every time I executed my tests. And I'm a guy who runs the tests every time a file is changed.

I wrote this script to help managing the process. It runs the tests and rebuilds the test running image if the Gemfile changed.



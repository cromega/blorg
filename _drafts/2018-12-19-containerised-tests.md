---
author: cromega
layout: json
title: containerised tests
date: Wed Dec 19 17:13:32 UTC 2018
permalink: /posts/containerised-tests/
tags: [geek]
category: dev
---

I know that mocking is good, mocking is great but mocking also sucks so I try not to overdo it. If an operation doesn't take a long time and it has consistent results (eg: writing to a file), I usually don't mock it.

In ruby it would be easy to stub `File.write` but then the test is tied to an implementation detail and it will break as soon as it is changed to one of the 47 other ways of writing stuff into a file. Plus it's not nearly as easy to do in other programming languages.

Long story short, if the purpose (or, satan forbid, side effect) of my class is writing a file, I want to test that very behaviour.

Files, however, represent state. And stateful tests are not good because that state can leak into the next test run.

<!-- more -->

Of course smart test setup logic can help mitigate this - I don't like relying on teardown - but what's even better is running the test suite in a container. It's what any self-respecting CI system does anyway.

Running rspec in a container is nothing tricky but I quickly got tired of having to wait for bundle every time I executed my tests. And I'm one of those maniacs who run the tests every time a file is changed.

I wrote this script to help managing the process. It runs the tests and rebuilds the test running image if certain files (Gemfile.lock, spec/Dockerfile) changed.



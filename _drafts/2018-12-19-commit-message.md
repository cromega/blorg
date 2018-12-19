---
author: cromega
layout: json
title: commit message
date: Wed Dec 19 16:46:47 UTC 2018
permalink: /posts/commit-message/
tags: [geek]
category: dev
---

We all know that naming things can be a tough nut to crack. There are many things to give names to and commit messages are one of the notoriously difficult ones.

Sometimes, however, you see gems that can restore your faith in humanity even if only for a very short time.

<!-- more -->

Recenelty I've worked with Farmdrop and as I was poking around in one of their repos I stumbled upon a small yaml file with the following content:

```yaml
egg:
- eggplant
```

I got curious and I did the first sensible thing: `git blame`, even though I expected it to be a waste of time because no one ever writes useful commit messages that contain informatoin aboud:

* what's in the commit and
* why adding/modifying/deleting that code was necessary.


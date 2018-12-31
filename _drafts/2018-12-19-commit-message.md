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

Sometimes, however, you see gems that can restore **some** faith in humanity. A tiny bit, but still.

<!-- more -->

Recently I've worked with the great people at Farmdrop and as I was poking around in one of their repos I stumbled upon a small yaml file with the following content:

```yaml
$ cat search_excludes.yml

egg:
- eggplant
```

I got curious and I did the first sensible thing: `git blame`. I didn't have high hopes as I expected to find something along the lines of `add search exclude configuration`, or `add eggplant to search excludes` or, even `add ALL the things` (but that's silly, no one commits with a message like that, right?)

Generally, there are 2 things I expect a commit message to communicate:

* a very succint summary of what's in the commit

And, quite often, even more importantly:

* why adding/modifying/deleting that code was necessary, as in what value it delivers

Much to my surprise, this is what I found:

```
Don't return Aubergine when people search for egg
````

And this, my friend, is a commit message.

Just by reading this line I know the following:

* What this file is and how it works
* What feature this commit is part of
* What this file is for listing prefix-word lists to exclude certain items from searches when the user searches for something that has a matching prefix. I know what this file does and I know why it was necessary.

If in 2 years time someone has to find out why this file exists they can just run git blame and they will immediately know.


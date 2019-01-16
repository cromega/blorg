---
author: cromega
layout: json
title: On the commitments we make
date: Wed Jan 16 18:10:47 UTC 2019
permalink: /posts/on-the-commitments-we-make/
tags: [geek]
category: dev
---

We all know that naming things can be a tough nut to crack. There are many
things to give names to and commit messages are one of the notoriously
difficult ones.

Quite often it's too easy to sum up a commit with a message that's too
abstract to be any useful. Think of `add search configuration`. Anyone who
opens that commit will see that a configuration file was added, most likely
the file name or the path will tell them that it is indeed a configuration
for search. The commit message doesn't carry any extra information on top of
what's obvious at a glance.

If half a year later (or as a new member of the team) I find that file and
want to figure out why it's there (what is it part of? is it still needed?),
that commit message will be completely unhelpful.

<!-- more -->

Generally, there are 2 things I expect a commit message to communicate:

* a very succinct summary of what's in the commit, and quite often even more importantly:
* why adding/modifying/deleting that code was necessary

In my experience the smaller and more specific the commit is, the more
important answering the **why** becomes. A chunkier commit can usually be
neatly summed up with something that says which feature the change was part
of. But take a commit for example, a file move. If you run git blame you
probably want to find out something about that operation. Would `move file`
explain anyting? I can see that a file was moved from a folder to another
one. Why was it moved? Does it need to be in that folder for some reason? Can
I move it back or somewhere else?

The perfect commit message tells us both about what and why.

Recently I've worked with the great people at
[Farmdrop](https://www.farmdrop.com) and as I was poking around in one of
their repos I stumbled upon a small yaml file with the following content:

```yaml
$ cat config/search_excludes.yml

egg:
- eggplant
```

I got curious and I did the first sensible thing: `git blame`. I didn't have
high hopes as I expected to find something along the lines of `add search
exclude configuration`, or `add eggplant to search excludes` or, even `add
ALL the things` (but that's silly, no one commits with a message like that,
right?)

Much to my surprise, this is what I found:

```
Don't return Aubergine when people search for egg
````

And this, my friend, is a commit message. Now I know the following:

* It's a collection of prefix-word lists
* It's definitely important as it's part of the logic that tweaks search results
* It works by listing a word and all the items that need to be excluded for that search

If in a year's time someone has to find out why this file exists they can just
run git blame and they will immediately know.

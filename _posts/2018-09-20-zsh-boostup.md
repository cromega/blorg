---
author: cromega
layout: json
title: zsh boostup
date: Thu Sep 20 09:15:44 UTC 2018
permalink: /posts/zsh-boostup/
tags: geek
category: dev
---

## I added these lines to my zshrc and you won't believe what happened next!

I use [oh my zsh](https://github.com/robbyrussell/oh-my-zsh) with a bunch of
defaults and a few things of my own. I wouldn't call my config bloated but it's
definitely not as snappy as it could be. However, a few tools I started using
recently shovelled a few more tenths of a second onto the shell startup time to
the point that it became annoying.

<!-- more -->

There's not a whole lot you can do to profile zsh startup but there's a simple way to find the biggest offenders:

```sh
zsh -vx
```

This will debug print everything zsh does during startup and you can easily spot it when it hangs for a bit.

Not surprisingly, I found that without [rbenv](https://github.com/rbenv/rbenv) and [nvm](https://github.com/creationix/nvm) things were much quicker. Nvm is pretty damn slow to load.

There are obvious ways to lazy load certain things, one way is to wrap
library initialisation calls in a function, let's call it `loadrbenv()`.

The main problem with this approach is that you have to remember to call
`loadrbenv` in every shell you open.

What I wanted was to lazy load rbenv **automatically** when needed.

I came up with a neat little trick to create temporary stubs. It works like this:

```sh
loadrbenv() {
  # do the slow stuff here
}

rbenv() {
  unfunction rbenv # this will remove the stub
  loadrbenv
  rbenv $@ # call the real command with the arguments
}
```

With a bit of shell "metaprogramming":

```sh
stub_once() {
  eval "$1() { unfunction $1; $2; $1 \$@ }"
}

stub_once rbenv loadrbenv
stub_once ruby loadrbenv
stub_once bundle loadrbenv

stub_once nvm loadnvm
stub_once node loadnvm
stub_once npm loadnvm
```

It's not perfect, calling `rbenv` and then `ruby` will both run loadrbenv once but until it turns out to be a problem I don't care.

I haven't tested it but `unset -f function_name` should work to the same effect in Bash.

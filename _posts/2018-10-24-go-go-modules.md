---
author: cromega
layout: post
title: Go Go modules
tags: [geek]
---

## Ever wanted to set GOPATH on fire? Now you can.

Google finally decided - quite commendably - that ~7 years of rage against the
conventions to organise Go code was enough. Golang 1.11 introduced a new feature
called modules, experimental for now, which is to supercede the GOPATH based
approach.

<!-- more -->

A module is a "unit of source code interchange and versioning". A module can
define its dependencies with version locking. Think Gemfiles, kinda. The good
thing is that when `go` notices it's running in a module context it will ignore
the GOPATH automatically and do sensible things.

## Getting started

I have a simple project with a few vendored dependencies, this is how I
converted it into a module:

```sh
# clone the repo somewhere NOT under GOPATH
cd keyguard
go mod init github.com/cromega/keyguard
```

Et voilà. &#x1f44d;

`go.mod` was created with some dependency information in it.

```
module github.com/cromega/keyguard

require github.com/GeertJohan/yubigo v0.0.0-20140521141543-b1764f04aa9b
```

More about the version notation a bit later. Let's see if it works:

```sh
unset GOPATH
go mod download # if you add deps
go test
go build
```

Notice that there's an additional file, `go.sum`. This file contains
cryptographic checksums of the dependencies and should also be version
controlled.

## Using the module file

Adding a new dependency is an extra line in the mod file:

```
require "github.com/julienschmidt/httprouter v1.2.0"
```

Go is fussy about versions, you can really only import projects that have valid
`semver` tags. If you want to require a commit you can specify a
"pseudo-version" which has the following syntax `v0.0.0-yyyymmddhhmmss-commit`

```
require "github.com/foo/bar
v0.0.0-20181024000000-348b672cd90d8190f8240323e372ecd1e66b59dc
```

The timestamp in the middle can be the date of the commit, the date the
dependency was added or all 0s if you don't care.

## Vendoring

I'm a big fan of vendoring dependencies - at least for projects with a
non-ridiculous amount of deps. To make the module system work with vendored
source code, just build it like this:

```sh
go build -mod=vendor
```

If you want to turn your module-defined dependencies into vendored deps, just
run

```sh
go mod vendor
```

It's cool because your codebase will work nicely with or without a
module-enabled version of Go.

Keep in mind that vendoring will be retired at some point along with GOPATH.

Google recommends using the module format even if your project doesn't have
dependencies just to force Go to switch to module mode. Building your project
with an older toolchain should just work as long as the folder is under GOPATH.


---
author: cromega
layout: json
title: AWS poetry
date: Tue Oct 30 10:06:03 UTC 2018
permalink: /posts/aws-poetry/
tags: [geek]
category: dev
---

## Art appreciation minutes!

I was playing around with EKS when a somewhat cryptic error message hit me.

<!-- more -->

What I was actually doing was trying to understand how the tool that provides a token for an EKS cluster works. FYI, the flow uses [this tool](https://github.com/kubernetes-sigs/aws-iam-authenticator).

As I executed the command I got this well-crafted chain of errors:

```
$ aws-iam-authenticator token -i eks-test
could not get token: NoCredentialProviders: no valid providers in chain.Deprecated.
```

As a friend of mine pointed it out, it almost reads like a haiku:


*Could not get token.*<br />
*NoCredentialProviders.*<br />
*Is Deprecated.*<br />

A thing of beauty.


---
author: cromega
layout: json
title: Testing static sites locally
date: Tue Sep 25 15:22:49 UTC 2018
permalink: /posts/testing-static-sites-locally/
tags: [geek]
category: dev
---

## How to serve static content for RSpec like a boss

Since this blog contains enough JavaScript garbage that it wouldn't even load
without it - I know, it's a horrible thing and the authors of static site
generators are rolling in their grave in unison - I thought I could recover
some engineering karma points if at least the site was covered with some
automated browser tests.

<!-- more -->

The obvious solution would've been to start the Jekyll server and run tests
against it but I didn't like the idea. I would've had to manage the jekyll
process and while it's not particularly difficult to get sufficiently right, it
felt like solving the wrong problem. I wanted to test the final generated
content (the result of `jekyll build`) rather than content served by Jekyll's
built-in auto reloading generator)

I turned to the ever useful [Sinatra](http://sinatrarb.com/) to be my friend
once again.

```ruby
class Blog < Sinatra::Base
  set :root, "_site" # This folder contains the output of jekyll build
  set :static, true
  set :public_folder, settings.root

  get "*" do
    path = params["splat"].first
    File.read("#{settings.root}/#{path}/index.html")
  end
end

Capybara.app = Blog
```

I dumped it in my `spec_helper` and it works like a charm. With `static`
enabled it will serve the assets located under `public_folder`. The only logic
needed was to make it respond with the `index.html` files that get generated for
each post under a folder.

A bit more plumbing to have a nice rspec experience:

```ruby
RSpec.configure do |config|
  config.before :suite do
    FileUtils.cp "spec/ui/fixtures/test-article.md", "_drafts"

    `bundle exec jekyll clean`
    `bundle exec jekyll build --drafts`
  end

  config.after :suite do
    FileUtils.rm "_drafts/test-article.md"
  end
end
```

Managing the test post is the only ugly cog in the machine but I couldn't find
a better way to seed the site with some content the tests can always rely on.

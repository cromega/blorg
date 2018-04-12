var App = function() {
  var _templates = [];
  var _initialised = false;

  var _compileTemplates = function() {
    var templates = ["posts", "post", "sidebar-posts"];
    templates.forEach(function(name) {
      template = `template/${name}`
      var source = document.getElementById(template).innerHTML;
      _templates[template] = Handlebars.compile(source);
    });
  }

  return {
    init: function() {
      if (_initialised) {
        console.log("reinit attempted");
        return;
      }

      _compileTemplates();
      _initialised = true;
      console.log("init done");
    },
    render: function(template, data) {
      return _templates[`template/${template}`](data);
    }
  }
}

var app;

document.addEventListener("DOMContentLoaded", function() {
  app = App();
  app.init();

  if (window.location.href.indexOf("#") < 0) {
    getPosts();
  } else {
    var permalink = window.location.href.split("#").pop();
    getPost(permalink);
  }

  updateSidebarLinks("dev");
});

var getPosts = function() {
  ajax("/posts.json", {}, function(err, body, xhr) {
    if (err) {
      console.log(err);
      return;
    }

    u("#content").html(app.render("posts", {posts: body}));

    u("a[data-post-url]").on("click", function(e) {
      var postUrl = u(this).data("post-url");
      getPost(postUrl);
    })
  });
}

var getPost = function(url) {
  ajax(url, {}, function(err, body, xhr) {
    if (err) {
      console.log(err);
      return;
    }

    u("#content").html(app.render("post", body))
    window.history.pushState("main page", "main page", "#" + body.url);
  })
}

var updateSidebarLinks = function(category) {
  ajax(`/categories/${category}.json`, {}, function(err, body, _) {
    if (err) {
      console.log(err);
      return;
    }
    console.log(body);

    u("#sidebar_post_links").html(app.render("sidebar-posts", {posts: body}))

    u(".post-link").on("click", function(e) {
      var postUrl = u(this).data("post-url");
      getPost(postUrl);
    })
  });
}


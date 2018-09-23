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
  fetch("/posts.json")
  .then(response => response.json())
  .then(data => {
    u("#content").html(app.render("posts", {posts: data}));

    u("a[data-post-url]").on("click", function(e) {
      var postUrl = u(this).data("post-url");
      getPost(postUrl);
    })
  })
  .catch(err => console.log(err))
}

var getPost = function(url) {
  fetch(url)
  .then(response => response.json())
  .then(data => {
    u("#content").html(app.render("post", data))
    window.history.pushState("main page", "main page", "#" + data.url);
  })
  .catch(err => console.log(err));
}

var updateSidebarLinks = function(category) {
  fetch(`/categories/${category}.json`)
  .then(response => response.json())
  .then(data => {
    u("#sidebar_post_links").html(app.render("sidebar-posts", {posts: data}))

    u(".post-link").on("click", function(e) {
      var postUrl = u(this).data("post-url");
      getPost(postUrl);
    });
  })
  .catch(err => console.log(err));
}


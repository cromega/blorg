var App = function(page) {
  var _page = page;
  var _history = [];
  var _templates = {};
  ["posts", "post", "sidebar-posts"].forEach(function(template) {
    var name = `template/${template}`
    var source = _page.getElementById(name).innerHTML;
    _templates[name] = Handlebars.compile(source);
  });

  window.addEventListener("popstate", function() { _goBack(); });

  var _goBack = function() {
    if (_history.length == 0) {return;}
    var hist = _history.pop();

    if (hist.indexOf("#") > -1) {
      _getPost(hist.replace("#", ""), pushHistory = false);
    } else {
      getPosts();
    }
  };

  var _render = function(template, data) {
    return _templates[`template/${template}`](data);
  }

  _getPost = function(url, pushHistory = true) {
    fetch(url)
    .then(response => response.json())
    .then(data => {
      u("#content").html(_render("post", data))
      if (pushHistory) {
        _history.push(window.location.href);
        window.history.pushState({previousPage: window.location.href}, "", "#" + url);
      }
    })
    .catch(err => console.log(err));
  }

  return {
    render: _render,
    getPost: _getPost,
  }
}

var app;

document.addEventListener("DOMContentLoaded", function() {
  app = new App(document);

  if (window.location.href.indexOf("#") < 0) {
    getPosts();
  } else {
    var permalink = window.location.href.split("#").pop();
    app.getPost(permalink);
  }

  updateSidebarLinks("dev");
});

var getPosts = function() {
  fetch("/posts.json")
  .then(response => response.json())
  .then(data => {
    u("#content").html(app.render("posts", {posts: data}));

    u("#content a[data-post-url]").off("click").on("click", function(e) {
      e.preventDefault();
      var postUrl = u(this).data("post-url");
      app.getPost(postUrl);
    })
  })
  .catch(err => console.log(err))
}

var updateSidebarLinks = function(category) {
  fetch(`/categories/${category}.json`)
  .then(response => response.json())
  .then(data => {
    u("#sidebar_post_links").html(app.render("sidebar-posts", {posts: data}))

    u("#sidebar .post-link").off("click").on("click", function(e) {
      e.preventDefault();
      var postUrl = u(this).data("post-url");
      app.getPost(postUrl);
    });
  })
  .catch(err => console.log(err));
}


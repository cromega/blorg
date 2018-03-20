var blorgTemplates = {};

document.addEventListener("DOMContentLoaded", function() {
  compileTemplates();
  if (window.location.href.indexOf("#") < 0) {
    getPosts();
  } else {
    var permalink = window.location.href.split("#").pop();
    getPost(permalink);
  }
});

var compileTemplates = function() {
  var templates = ["template/posts", "template/post"];
  templates.forEach(function(template) {
    var source = document.getElementById(template).innerHTML;
    blorgTemplates[template] = Handlebars.compile(source);
  });
}

var getPosts = function() {
  ajax("/posts.json", {}, function(err, body, xhr) {
    if (err) {
      console.log(err);
      return;
    }

    u("#content").html(blorgTemplates["template/posts"]({
      posts: body
    }));

    u(".post-link").on("click", function(e) {
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

    u("#content").html(blorgTemplates["template/post"](body));
    window.history.pushState("main page", "main page", "#" + body.url);
  })
}


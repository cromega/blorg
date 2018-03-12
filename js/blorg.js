var blorgTemplates = {};

document.addEventListener("DOMContentLoaded", function() {
  compileTemplates();
  getPosts();
});

var compileTemplates = function() {
  var templates = ["posts_template", "post_template"];
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

    u("#posts_container").html(blorgTemplates.posts_template({
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

    u("#post_container").html(blorgTemplates.post_template(body));

    u("#posts_container").toggleClass("hidden");
    u("#post_container").toggleClass("hidden");
  })
}


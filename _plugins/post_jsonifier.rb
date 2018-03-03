require "json"

module Jekyll
  module PostJsonifier
    def post_jsonify(post)
      {
        title: post.title,
        content: post.content
      }.to_json4sdfsdf
    end
  end
end

Liquid::Template.register_filter(Jekyll::PostJsonifier)

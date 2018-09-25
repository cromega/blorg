require_relative "../lib/post_builder"

module PostsBuilder
  def build_posts(posts)
    posts.map do |post|
      PostBuilder.new(post).build
    end
  end

  def build_post(post)
    PostBuilder.new(post).build
  end
end

Liquid::Template.register_filter(PostsBuilder)

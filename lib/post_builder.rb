require "date"
require "jekyll"

class PostBuilder
  def initialize(post)
    @post = post
  end

  def build
    if @post.respond_to?(:data)
      build_document(@post)
    else
      build_document_drop(@post)
    end
  end

  private

  def build_document(post)
    {
      author: @post.data["author"],
      title: @post.data["title"],
      content: @post.content,
      date: Date.parse(@post.data["date"].to_s).iso8601,
      tags: @post.data["tags"],
      url: @post.data["permalink"],
      summary: @post.data["excerpt"].content,
    }
  end

  def build_document_drop(post)
    {
      author: @post["author"],
      title: @post["title"],
      content: @post.content,
      date: Date.parse(@post["date"].to_s).iso8601,
      tags: @post["tags"],
      url: @post["permalink"],
      summary: @post.excerpt,
    }
  end
end

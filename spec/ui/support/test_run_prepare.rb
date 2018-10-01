class TestRunPrepare
  def create_test_post
    File.write("_drafts/test-article.md", File.read("spec/ui/fixtures/test-article.md") % DateTime.now.strftime("%a %b %d %H:%M:%S %Z %Y"))
  end

  def build_content
    `bundle exec jekyll clean`
    `bundle exec jekyll build --drafts`
  end

  def self.clean_up
    FileUtils.rm "_drafts/test-article.md"
  end
end



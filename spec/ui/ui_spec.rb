require "ui/ui_spec_helper"

describe "The Blorg:", type: :feature, js: true do
  describe "The main page" do
    it "shows the summaries" do
      visit "/"
      expect(page).to have_content "Read the whole thing!"
    end
  end

  describe "opening a permalink" do
    before do
      visit "#/posts/test-post.json"
    end

    it "shows the post" do
      expect(page).to have_content "More test text"
    end
  end

  describe "clicking on read more" do
    before do
      visit "/"
      first(:link, "Read the whole thing!").click
    end

    it "shows the whole article" do
      expect(page).to have_content "More test text"
    end

    it "adds the permalink fragment to the current address" do
      expect(URI.parse(page.current_url).fragment).to eq "/posts/test-post.json"
    end
  end

  describe "navigating backwards after visiting articles" do
    before do
      visit "/"
      click_on("test post")
      click_on("the author")
    end

    it "follows the history correctly" do
      page.driver.go_back
      expect(URI.parse(page.current_url).fragment).to eq "/posts/test-post.json"
      expect(page).to have_content "Test markdown article"

      page.driver.go_back
      expect(URI.parse(page.current_url).fragment).to eq nil
      expect(page).to have_content "Read the whole thing!"
    end
  end
end

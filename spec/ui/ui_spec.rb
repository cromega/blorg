require "ui/ui_spec_helper"

describe "The Blorg:", type: :feature, js: true do
  describe "The main page" do
    it "shows the summaries" do
      visit "/"
      expect(page).to have_content "Read the whole thing!"
    end
  end

  describe "opening a permalink" do
    let(:url) { "#/posts/test-post/" }

    before do
      visit url
    end

    it "shows the post" do
      expect(page).to have_content "More test text"
    end

    context "when the permalink is direct link to json" do
      let(:url) { "#/posts/test-post.json" }
      it "sets the address to the correct folder url" do
        visit "#/posts/test-post.json"
        sleep 0.3
        expect(URI.parse(page.current_url).fragment).to eq "/posts/test-post/"
      end
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
      expect(URI.parse(page.current_url).fragment).to eq "/posts/test-post/"
    end
  end

  describe "navigating backwards after visiting articles" do
    before do
      visit "/"
      within "#content" do
        click_on("test post")
      end
      click_on("the author")
    end

    it "follows the history correctly" do
      page.driver.go_back
      sleep 0.3
      expect(URI.parse(page.current_url).fragment).to eq "/posts/test-post/"
      expect(page).to have_content "Test markdown article"

      page.driver.go_back
      sleep 0.2
      expect(URI.parse(page.current_url).fragment).to eq nil
      expect(page).to have_content "Read the whole thing!"
    end
  end
end

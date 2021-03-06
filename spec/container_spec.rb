require "spec_helper"
require "docker"
require "net/http"

describe "Blorg container" do
  around(:all) do |examples|
    image = Docker::Image.build_from_dir(".")
    container_opts = {
      Image: image.id,
      ExposedPorts: { '80/tcp' => {} },
      HostConfig: {
        PortBindings: {
          '80/tcp' => [{HostPort: '3456'}]
        }
      }
    }
    container = Docker::Container.create(container_opts)
    container.start

    examples.run

    container.kill
    container.remove
  end

  it "serves the content via HTTP" do
    response = Net::HTTP.get_response(URI('http://localhost:3456'))
    expect(response).to be_a Net::HTTPSuccess
    expect(response.body).to have_content "The α and the cromega"
  end

  it "can serve an article" do
    response = Net::HTTP.get_response(URI('http://localhost:3456'))
    page = Capybara::Node::Simple.new(response.body)
    link = page.first(".title a", match: :first)
    response = Net::HTTP.get_response(URI("http://localhost:3456/#{link[:href]}"))
    expect(response).to be_a Net::HTTPSuccess
  end
end


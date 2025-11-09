# frozen_string_literal: true

require "fileutils"

RSpec.describe "wytch new", type: :integration do
  let(:site_path) { File.expand_path("../test_site", __dir__) }

  before do
    FileUtils.rm_rf(site_path) if Dir.exist?(site_path)
  end

  before do
    Wytch.reset_site!
  end

  after do
    FileUtils.rm_rf(site_path) if Dir.exist?(site_path)
  end

  it "creates a new site and builds it successfully" do
    # Generate a new site with --local option to use current working version
    cli = Wytch::CLI.new
    cli.invoke(:new, [site_path], local: true)

    # Verify directory structure was created
    expect(Dir.exist?(site_path)).to be true
    expect(File.exist?(File.join(site_path, "Gemfile"))).to be true
    expect(File.exist?(File.join(site_path, "config.rb"))).to be true
    expect(File.exist?(File.join(site_path, ".gitignore"))).to be true
    expect(Dir.exist?(File.join(site_path, "content"))).to be true
    expect(File.exist?(File.join(site_path, "content/index.rb"))).to be true
    expect(Dir.exist?(File.join(site_path, "src"))).to be true
    expect(Dir.exist?(File.join(site_path, "src/test_site"))).to be true
    expect(File.exist?(File.join(site_path, "src/test_site/index_view.rb"))).to be true
    expect(File.exist?(File.join(site_path, "src/test_site/html_helpers.rb"))).to be true
    expect(Dir.exist?(File.join(site_path, "public"))).to be true
    expect(File.exist?(File.join(site_path, "public/robots.txt"))).to be true

    # Change to the site directory and build
    Dir.chdir(site_path) do
      builder = Wytch::Builder.new
      builder.build

      # Verify build output
      expect(Dir.exist?("build")).to be true
      expect(File.exist?("build/index/index.html")).to be true
      expect(File.exist?("build/robots.txt")).to be true

      # Verify index.html content
      index_html = File.read("build/index/index.html")
      expect(index_html).to include("Welcome to Wytch")
      expect(index_html).to include("Beware the wytch!")
      expect(index_html).to include("Your site is ready.")

      # Verify robots.txt content
      robots_txt = File.read("build/robots.txt")
      expect(robots_txt).to include("User-agent: *")
      expect(robots_txt).to include("Allow: /")
    end
  end
end

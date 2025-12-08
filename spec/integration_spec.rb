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
    expect(File.exist?(File.join(site_path, "src/test_site/home_view.rb"))).to be true
    expect(File.exist?(File.join(site_path, "src/test_site/post_view.rb"))).to be true
    expect(File.exist?(File.join(site_path, "src/test_site/post_helpers.rb"))).to be true
    expect(File.exist?(File.join(site_path, "src/test_site/feed_view.rb"))).to be true
    expect(File.exist?(File.join(site_path, "src/test_site/feed_helper.rb"))).to be true
    expect(Dir.exist?(File.join(site_path, "content/posts"))).to be true
    expect(File.exist?(File.join(site_path, "content/posts/hello-world.rb"))).to be true
    expect(File.exist?(File.join(site_path, "content/sitemap.rb"))).to be true
    expect(File.exist?(File.join(site_path, "content/feed.rb"))).to be true
    expect(Dir.exist?(File.join(site_path, "public"))).to be true
    expect(File.exist?(File.join(site_path, "public/robots.txt"))).to be true

    # Change to the site directory and build
    Dir.chdir(site_path) do
      builder = Wytch::Builder.new
      builder.build

      # Verify build output
      expect(Dir.exist?("build")).to be true
      expect(File.exist?("build/index.html")).to be true
      expect(File.exist?("build/robots.txt")).to be true

      # Verify index.html content
      index_html = File.read("build/index.html")
      expect(index_html).to include("Welcome to Wytch")
      expect(index_html).to include("Posts")
      expect(index_html).to include("Hello World")

      # Verify robots.txt content
      robots_txt = File.read("build/robots.txt")
      expect(robots_txt).to include("User-agent: *")
      expect(robots_txt).to include("Allow: /")

      # Verify sitemap.xml
      expect(File.exist?("build/sitemap.xml")).to be true
      sitemap_xml = File.read("build/sitemap.xml")
      expect(sitemap_xml).to include('<?xml version="1.0" encoding="UTF-8"?>')
      expect(sitemap_xml).to include("http://www.sitemaps.org/schemas/sitemap/0.9")
      expect(sitemap_xml).to include("<loc>/</loc>")
      expect(sitemap_xml).to include("/posts/hello-world")
      expect(sitemap_xml).not_to include("/sitemap.xml")

      # Verify feed.xml
      expect(File.exist?("build/feed.xml")).to be true
      feed_xml = File.read("build/feed.xml")
      expect(feed_xml).to include('<?xml version="1.0" encoding="UTF-8"?>')
      expect(feed_xml).to include("http://www.w3.org/2005/Atom")
      expect(feed_xml).to include("<title>Hello World</title>")
      expect(feed_xml).to include("/posts/hello-world")
    end
  end
end

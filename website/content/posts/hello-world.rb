# frozen_string_literal: true

add Wytch-site::PostHelpers
view Wytch-site::PostView

@metadata[:title] = "Hello World"

content_markdown <<~MD
  This is your first blog post.

  Write your content in **markdown**.
MD

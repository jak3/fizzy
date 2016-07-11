set :build_dir, "website"

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Change the asset's filename every time you change one of your assets.
activate :asset_hash

# Create a folder for each `.html` file and place the built template file as
# the index of that folder.
activate :directory_indexes

# Manage assets with sprockets.
require "sprockets/es6"
activate :sprockets do |c|
  c.expose_middleman_helpers = true
  c.supported_output_extensions << ".es6"
end

# Development-specific configuration.
configure :development do
  set :debug_assets, true
end

# Build-specific configuration.
configure :build do
  # Minify CSS on build.
  activate :minify_css

  # Minify Javascript on build.
  activate :minify_javascript

  # Serve compressed files to user agents that can handle it.
  activate :gzip
end

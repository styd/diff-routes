require_relative "pry_rails_diff_routes/version"

if defined? Rails
  require_relative 'pry_rails_diff_routes/railtie'
  require_relative 'pry_rails_diff_routes/commands'
  require_relative 'pry_rails_diff_routes/routes_diff_processor'
end

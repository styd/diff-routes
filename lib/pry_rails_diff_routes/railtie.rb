module PryRailsDiffRoutes
  class Railtie < Rails::Railtie
    # Cribbed from PryRails::Railtie
    # Removed Rails versions < 5 checking as they are no longer supported.
    console do
      unless defined? PryRails
        require 'pry'

        Rails.application.config.console = Pry

        require "rails/console/app"
        require "rails/console/helpers"
        TOPLEVEL_BINDING.eval('self').extend ::Rails::ConsoleMethods
      end

      require 'pry_rails_diff_routes/commands'

      DiffRoutes.new.save_routes(Rails.application.routes.routes)
    end
  end
end

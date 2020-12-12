require_relative '../route_wrapper'

module PryRailsDiffRoutes
  class DiffRoutes < Pry::ClassCommand
    R_MODE = 1; M_MODE = 2; N_MODE = 4; A_MODE = 7

    singleton_class.attr_accessor :_previous_routes

    match 'diff-routes'
    group 'Rails'
    description 'Show the difference you made in routes.'
    banner <<-BANNER
      Usage: diff-routes [-S|-R|-M|-N]

      `diff-routes' displays changes in routes.

      # Save current routes as the basis for changes
      diff-routes -S

      # Display routes that have been removed
      diff-routes -R

      # Display modified routes
      diff-routes -M

      # Display new routes
      diff-routes -N
    BANNER

    def options(opt)
      opt.on :S, "save", "Save current routes",
             as: String
      opt.on :R, "removed", "Show removed routes",
             as: String
      opt.on :M, "modified", "Show modified routes",
             as: String
      opt.on :N, "new", "Show new routes",
             as: String
    end

    def process
      Rails.application.reload_routes!
      all_routes = Rails.application.routes.routes

      return save_routes(all_routes) if opts[:S]

      removed_mode = opts[:R] ? R_MODE : 0
      modified_mode = opts[:M] ? M_MODE : 0
      new_mode = opts[:N] ? N_MODE : 0
      display_mode = removed_mode | modified_mode | new_mode

      output.puts process_diff(all_routes, display_mode)
    end

    # `opts[:S]`.
    def save_routes(routes)
      DiffRoutes._previous_routes = wrap_routes(routes)
      nil
    end

    def wrap_routes(routes)
      prev_name = nil
      routes.reject(&:internal).map do |route|
        if route.name.nil?
          route.instance_variable_set(:@name, prev_name)
        else
          prev_name = route.name
        end

        RouteWrapper.new(route)
      end
    end

    def process_diff(current_routes, mode)
      routes =
        RoutesDiffProcessor.new(
          DiffRoutes._previous_routes,
          wrap_routes(current_routes),
          mode
        )

      if routes.changed?
        routes
      else
        "No routes changed."
      end
    end

    Commands.add_command(self)
  end
end

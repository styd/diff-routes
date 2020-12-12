require_relative 'formatters/removed_routes_formatter'
require_relative 'formatters/modified_routes_formatter'
require_relative 'formatters/new_routes_formatter'

module PryRailsDiffRoutes
  class RoutesDiffProcessor
    def initialize(previous_routes, current_routes, display_mode)
      @previous = previous_routes
      @current = current_routes
      @mode = display_mode.zero? ? DiffRoutes::A_MODE : display_mode

      @removed, @modified, @new = process_diff if changed?
    end

    def changed?
      @previous != @current
    end

    def process_diff
      inner_join = @previous & @current
      removed_routes = @previous - inner_join
      new_routes = @current - inner_join

      modified_routes = {}

      removed_routes.reject! do |r_route|
        catch :modified do
          new_routes.each do |n_route|
            if n_route.verb == r_route.verb && n_route.path == r_route.path
              modified_routes[r_route] = n_route
              new_routes.reject!{|route| route == n_route }

              throw :modified, true
            end
          end

          false
        end
      end

      [removed_routes, modified_routes, new_routes]
    end

    def show_removed?
      (@mode & DiffRoutes::R_MODE == DiffRoutes::R_MODE) && @removed.any?
    end

    def display_removed
      RemovedRoutesFormatter.new(@removed) if show_removed?
    end

    def show_modified?
      (@mode & DiffRoutes::M_MODE == DiffRoutes::M_MODE) && @modified.any?
    end

    def display_modified
      ModifiedRoutesFormatter.new(@modified) if show_modified?
    end

    def show_new?
      (@mode & DiffRoutes::N_MODE == DiffRoutes::N_MODE) && @new.any?
    end

    def display_new
      NewRoutesFormatter.new(@new) if show_new?
    end

    def to_s
      "#{display_removed}#{display_modified}#{display_new}"
    end
  end
end

require 'action_dispatch/routing/inspector'
require_relative 'util'

if RUBY_ENGINE == 'ruby'
  using Module.new {
    refine Hash do
      alias old_to_s to_s
      def to_s
        old_to_s.gsub(%r{\:(\w+)\=\>}, "\\1: ")
      end
    end
  }
end

module PryDiffRoutes
  class RouteWrapper < ActionDispatch::Routing::RouteWrapper
    include Util
    include Comparable

    alias_method :prefix, :name

    def <=>(other)
      self.prefix <=> other.prefix &&
        self.verb <=> other.verb &&
        self.reqs <=> other.reqs
    end

    def hash
      [self.prefix, self.verb, self.reqs].hash
    end

    def eql?(other)
      self == other
    end

    def to_s
      pad_lines <<~ROUTE, 1
        #{display_verb_and_path}
          #{display_prefix}
          #{display_controller}
          #{display_action}
          #{display_constraints}
      ROUTE
    end

    def display_verb_and_path
      "#{bold verb.ljust(6, ' ')} #{dim_format path}"
    end

    def display_prefix
      "#{arrow_key('Prefix')} #{prefix}"
    end

    def display_controller
      "#{arrow_key('Controller')} #{controller.camelize}Controller"
    end

    def display_action
      "#{arrow_key('Action')} ##{action}"
    end

    def display_constraints
      "#{arrow_key('Constraints')} #{constraints}"
    end
  end
end

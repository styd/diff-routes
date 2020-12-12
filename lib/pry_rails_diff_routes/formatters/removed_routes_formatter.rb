module PryRailsDiffRoutes
  class RemovedRoutesFormatter
    def initialize(routes)
      @routes = routes
    end

    def to_s
      <<~NEW
        #{Util.bold_red 'Removed:'}
        #{@routes.map(&:to_s).join("\n")}
      NEW
    end
  end
end

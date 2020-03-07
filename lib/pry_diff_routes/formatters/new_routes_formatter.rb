module PryDiffRoutes
  class NewRoutesFormatter
    def initialize(routes)
      @routes = routes
    end

    def to_s
      <<~NEW
        #{Util.bold_green 'New:'}
        #{@routes.map(&:to_s).join("\n")}
      NEW
    end
  end
end

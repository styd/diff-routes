module PryDiffRoutes::ModernHashFormat
  refine Hash do
    alias old_to_s to_s
    def to_s
      old_to_s.gsub(%r{\:(\w+)\=\>}, "\\1: ")
    end
  end
end

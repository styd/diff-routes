module PryDiffRoutes
  class ModifiedRoutesFormatter
    include Util

    def initialize(routes_changes)
      @routes_changes = routes_changes
    end

    def to_s
      <<~MODIFIED
        #{bold_yellow 'Modified:'}
        #{routes_diff}
      MODIFIED
    end

  private
    def routes_diff
      @routes_changes.map do |before, after|
        <<~CHANGES
          #{before.display_verb_and_path}
        #{prefix_changes(before, after)}
        #{controller_changes(before, after)}
        #{action_changes(before, after)}
        #{constraints_changes(before, after)}
        CHANGES
      end.join("\n")
    end

    def prefix_changes(before, after)
      if before.prefix != after.prefix
        pad_lines <<~DIFF.chomp, 2
          #{arrow_key('Prefix')}-#{highlight_red before.prefix}
                        +#{highlight_green after.prefix}
        DIFF
      else
        pad_lines before.display_prefix, 2
      end
    end

    def controller_changes(before, after)
      if before.controller != after.controller
        pad_lines <<~DIFF.chomp, 2
          #{arrow_key('Controller')}-#{highlight_red(before.controller.camelize + 'Controller')}
                        +#{highlight_green(after.controller.camelize + 'Controller')}
        DIFF
      else
        pad_lines before.display_controller, 2
      end
    end

    def action_changes(before, after)
      if before.action != after.action
        pad_lines <<~DIFF.chomp, 2
          #{arrow_key('Action')}-#{highlight_red('#' + before.action)}
                        +#{highlight_green('#' + after.action)}
        DIFF
      else
        pad_lines before.display_action, 2
      end
    end

    def constraints_changes(before, after)
      if before.constraints != after.constraints
        <<-DIFF.chomp
          #{arrow_key('Constraints')}-#{highlight_red before.constraints}
                        +#{highlight_green after.constraints}
        DIFF
      else
        pad_lines before.display_constraints, 2
      end
    end
  end
end

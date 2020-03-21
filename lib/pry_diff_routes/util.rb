require_relative 'modern_hash_format'

module PryDiffRoutes
  module Util
    using ModernHashFormat if RUBY_ENGINE == 'ruby'

    module_function

    def pad_lines(text="", pad_length=0)
      text.gsub(/^(.*)$/, ' ' * 2 * pad_length + "\\1")
    end

    def arrow_key(key)
      key.ljust(12, ' ') + '->'
    end

    def dim_format(text)
      text.sub(/(\(.:format\))$/, "\e[2m\\1\e[0m")
    end

    def highlight_red(text)
      "\e[1;30;41m#{text}\e[0m"
    end

    def highlight_green(text)
      "\e[1;30;42m#{text}\e[0m"
    end

    def bold(text)
      "\e[1m#{text}\e[0m"
    end

    def bold_red(text)
      "\e[1;31m#{text}\e[0m"
    end

    def bold_yellow(text)
      "\e[1;33m#{text}\e[0m"
    end

    def bold_green(text)
      "\e[1;32m#{text}\e[0m"
    end
  end
end

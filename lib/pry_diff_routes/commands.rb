require 'pry'

PryDiffRoutes::Commands = Pry::CommandSet.new

require_relative 'commands/diff_routes'

Pry.commands.import PryDiffRoutes::Commands

require 'pry'

PryRailsDiffRoutes::Commands = Pry::CommandSet.new

require_relative 'commands/diff_routes'

Pry.commands.import PryRailsDiffRoutes::Commands

require 'spec_helper'

RSpec.describe PryRailsDiffRoutes::RemovedRoutesFormatter do
  describe '#to_s' do
    it 'returns "Removed:" text and routes diff' do
      formatter = described_class.new([:removed_routes])

      expect(formatter.to_s).to match /Removed:/
      expect(formatter.to_s).to match /removed_routes/
    end
  end
end

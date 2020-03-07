require 'spec_helper'

RSpec.describe PryDiffRoutes::NewRoutesFormatter do
  describe '#to_s' do
    it 'returns "New:" text and routes diff' do
      formatter = described_class.new([:new_routes])

      expect(formatter.to_s).to match /New:/
      expect(formatter.to_s).to match /new_routes/
    end
  end
end

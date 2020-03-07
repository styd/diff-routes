require 'spec_helper'

RSpec.describe PryDiffRoutes::ModifiedRoutesFormatter do
  describe '#to_s' do
    before do
      allow_any_instance_of(described_class).to receive(:routes_diff).and_return 'routes diff'
    end

    it 'returns "Modified:" text and routes diff' do
      formatter = described_class.new(nil)

      expect(formatter.to_s).to match /Modified:/
      expect(formatter.to_s).to match /routes diff/
    end
  end
end

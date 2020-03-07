require 'spec_helper'

RSpec.describe PryDiffRoutes::RoutesDiffProcessor do
  describe '#changed?' do
    context 'when previous and current are different' do
      it 'returns true' do
        allow_any_instance_of(described_class).to receive(:process_diff)
        previous, current = 1, 2

        expect(described_class.new(previous, current, 0).changed?).to eq true
      end
    end

    context 'when previous and current are the same' do
      it 'returns false' do
        previous, current = 2, 2

        expect(described_class.new(previous, current, 0).changed?).to eq false
      end
    end
  end

  describe '#process_diff' do
    let(:processor) { described_class.new(0, 0, 0) }
    let(:route) { Struct.new(:verb, :path, :irrelevant) }
    let(:previous) { [
      route.new('GET', '/path', :prev),
      route.new('GET', '/path2', :prev2)
    ] }
    let(:current) { [
      route.new('GET', '/path2', :curr),
      route.new('GET', '/path3', :curr2)
    ] }

    before do
      processor.instance_variable_set(:@previous, previous)
      processor.instance_variable_set(:@current, current)
    end

    it 'returns removed, modified, and new routes respectively' do
      expect(processor.process_diff).to eq [
        # Removed Routes
        [route.new('GET', '/path', :prev)],

        # Modified Routes
        {route.new('GET', '/path2', :prev2) => route.new('GET', '/path2', :curr)},

        # New Routes
        [route.new('GET', '/path3', :curr2)]
      ]
    end
  end

  describe '#show_removed?' do
    let(:processor) { described_class.new(0, 0, 0) }

    before do
      processor.instance_variable_set(:@removed, [1])
    end

    context 'when mode is 7, 5, 3, or 1' do
      it 'returns true' do
        processor.instance_variable_set(:@mode, 7)
        expect(processor.show_removed?).to eq true

        processor.instance_variable_set(:@mode, 5)
        expect(processor.show_removed?).to eq true

        processor.instance_variable_set(:@mode, 3)
        expect(processor.show_removed?).to eq true

        processor.instance_variable_set(:@mode, 1)
        expect(processor.show_removed?).to eq true
      end
    end

    context 'otherwise' do
      it 'returns false' do
        processor.instance_variable_set(:@mode, 6)
        expect(processor.show_removed?).to eq false

        processor.instance_variable_set(:@mode, 4)
        expect(processor.show_removed?).to eq false

        processor.instance_variable_set(:@mode, 2)
        expect(processor.show_removed?).to eq false
      end
    end
  end

  describe '#display_removed' do
    context 'show_removed? is true' do
      it 'returns instance of PryDiffRoutes::RemovedRoutesFormatter' do
        allow_any_instance_of(described_class).to \
          receive(:show_removed?).and_return true

        expect(described_class.new(0, 0, 0).display_removed).to \
          be_instance_of(PryDiffRoutes::RemovedRoutesFormatter)
      end
    end

    context 'show_removed? is false' do
      it 'returns instance of PryDiffRoutes::RemovedRoutesFormatter' do
        allow_any_instance_of(described_class).to \
          receive(:show_removed?).and_return false

        expect(described_class.new(0, 0, 0).display_removed).to be_nil
      end
    end
  end

  describe '#show_modified?' do
    let(:processor) { described_class.new(0, 0, 0) }

    before do
      processor.instance_variable_set(:@modified, [1])
    end

    context 'when mode is 7, 6, 3, or 2' do
      it 'returns true' do
        processor.instance_variable_set(:@mode, 7)
        expect(processor.show_modified?).to eq true

        processor.instance_variable_set(:@mode, 6)
        expect(processor.show_modified?).to eq true

        processor.instance_variable_set(:@mode, 3)
        expect(processor.show_modified?).to eq true

        processor.instance_variable_set(:@mode, 2)
        expect(processor.show_modified?).to eq true
      end
    end

    context 'otherwise' do
      it 'returns false' do
        processor.instance_variable_set(:@mode, 5)
        expect(processor.show_modified?).to eq false

        processor.instance_variable_set(:@mode, 4)
        expect(processor.show_modified?).to eq false

        processor.instance_variable_set(:@mode, 1)
        expect(processor.show_modified?).to eq false
      end
    end
  end

  describe '#display_modified' do
    context 'show_modified? is true' do
      it 'returns instance of PryDiffRoutes::RemovedRoutesFormatter' do
        allow_any_instance_of(described_class).to \
          receive(:show_modified?).and_return true

        expect(described_class.new(0, 0, 0).display_modified).to \
          be_instance_of(PryDiffRoutes::ModifiedRoutesFormatter)
      end
    end

    context 'show_modified? is false' do
      it 'returns instance of PryDiffRoutes::RemovedRoutesFormatter' do
        allow_any_instance_of(described_class).to \
          receive(:show_modified?).and_return false

        expect(described_class.new(0, 0, 0).display_modified).to be_nil
      end
    end
  end

  describe '#show_new?' do
    let(:processor) { described_class.new(0, 0, 0) }

    before do
      processor.instance_variable_set(:@new, [1])
    end

    context 'when mode is 7, 6, 5, or 4' do
      it 'returns true' do
        processor.instance_variable_set(:@mode, 7)
        expect(processor.show_new?).to eq true

        processor.instance_variable_set(:@mode, 6)
        expect(processor.show_new?).to eq true

        processor.instance_variable_set(:@mode, 5)
        expect(processor.show_new?).to eq true

        processor.instance_variable_set(:@mode, 4)
        expect(processor.show_new?).to eq true
      end
    end

    context 'otherwise' do
      it 'returns false' do
        processor.instance_variable_set(:@mode, 3)
        expect(processor.show_new?).to eq false

        processor.instance_variable_set(:@mode, 2)
        expect(processor.show_new?).to eq false

        processor.instance_variable_set(:@mode, 1)
        expect(processor.show_new?).to eq false
      end
    end
  end

  describe '#display_new' do
    context 'show_new? is true' do
      it 'returns instance of PryDiffRoutes::RemovedRoutesFormatter' do
        allow_any_instance_of(described_class).to \
          receive(:show_new?).and_return true

        expect(described_class.new(0, 0, 0).display_new).to \
          be_instance_of(PryDiffRoutes::NewRoutesFormatter)
      end
    end

    context 'show_new? is false' do
      it 'returns instance of PryDiffRoutes::RemovedRoutesFormatter' do
        allow_any_instance_of(described_class).to \
          receive(:show_new?).and_return false

        expect(described_class.new(0, 0, 0).display_new).to be_nil
      end
    end
  end

  describe '#to_s' do
    it 'displays removed, modified, and new routes' do
      allow_any_instance_of(described_class).to receive(:display_removed).and_return('removed')
      allow_any_instance_of(described_class).to receive(:display_modified).and_return('modified')
      allow_any_instance_of(described_class).to receive(:display_new).and_return('new')

      expect(described_class.new(0, 0, 0).to_s).to eq 'removedmodifiednew'
    end
  end
end

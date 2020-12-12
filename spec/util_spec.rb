require 'spec_helper'

RSpec.describe PryRailsDiffRoutes::Util do
  include described_class

  describe '.pad_lines' do
    let(:lines) {
      " first line\n" +
      "second line\n"
    }

    context 'pad_length is 0' do
      it 'returns the lines' do
        expect(pad_lines lines).to eq lines
      end
    end

    context 'pad_length is more than 0' do
      it 'pads the lines by 2 times the pad_length' do
        expect(pad_lines lines, 3).to eq(
          "       first line\n" +
          "      second line\n"
        )
      end
    end
  end

  describe '.arrow_key' do
    it 'presents the key string in 12 column appended by arrow' do
      expect("#{arrow_key 'a'}\n#{arrow_key 'key'}\n").to eq <<~ARROW
        a           ->
        key         ->
      ARROW
    end
  end

  describe '.dim_format' do
    it 'dims the text "(.:format)" in path' do
      ::STDERR.puts dim_format '    exhibit: /path(.:format)'
      expect(dim_format '/path(.:format)').to eq "/path\e[2m(.:format)\e[0m"
    end
  end

  describe '.highlight_red' do
    it 'highlight text with red color' do
      ::STDERR.puts "    exhibit: #{highlight_red 'text'}"
      expect(highlight_red 'text').to eq "\e[1;41mtext\e[0m"
    end
  end

  describe '.highlight_green' do
    it 'highlight text with green color' do
      ::STDERR.puts "    exhibit: #{highlight_green 'text'}"
      expect(highlight_green 'text').to eq "\e[1;42mtext\e[0m"
    end
  end

  describe '.bold' do
    it 'bolds text' do
      ::STDERR.puts "    exhibit: #{bold 'text'}"
      expect(bold 'text').to eq "\e[1mtext\e[0m"
    end
  end

  describe '.bold_red' do
    it 'bolds text with red color' do
      ::STDERR.puts "    exhibit: #{bold_red 'text'}"
      expect(bold_red 'text').to eq "\e[1;31mtext\e[0m"
    end
  end

  describe '.bold_yellow' do
    it 'bolds text with yellow color' do
      ::STDERR.puts "    exhibit: #{bold_yellow 'text'}"
      expect(bold_yellow 'text').to eq "\e[1;33mtext\e[0m"
    end
  end

  describe '.bold_green' do
    it 'bolds text with green color' do
      ::STDERR.puts "    exhibit: #{bold_green 'text'}"
      expect(bold_green 'text').to eq "\e[1;32mtext\e[0m"
    end
  end
end

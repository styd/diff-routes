require 'spec_helper'
require 'pry_rails_diff_routes/modern_hash_format'

using PryRailsDiffRoutes::ModernHashFormat

RSpec.describe 'modern hash format', if: RUBY_ENGINE == 'ruby' do
  it 'prints hash in the new format' do
    expect({format:'json'}.to_s).to eq '{format: "json"}'
    expect({:format => 'json'}.to_s).to eq '{format: "json"}'
    expect({:format => :json}.to_s).to eq '{format: :json}'
    expect({format: :json}.to_s).to eq '{format: :json}'
  end
end

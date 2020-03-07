#
# Integration Tests
#

require 'spec_helper'
include Pry::Testable

RSpec.describe PryDiffRoutes::DiffRoutes do
  before do
    Rails.application = Class.new(Rails::Application)
    Rails.application.routes.draw do
      get :back, to: 'the#past'
      get :started, to: 'do#something'
    end

    PryDiffRoutes::Railtie.console.last.call
  end

  context 'default' do
    let(:existing_routes) { described_class._previous_routes }

    it "show all routes changes" do
      expect(existing_routes.count).to eq 2
      expect(pry_eval('diff-routes')).to match /No routes changed./

      Rails.application.routes.draw do
        get :ready, to: 'shine#again'
        get :back, to: 'the#future'
      end

      output = pry_eval('diff-routes')

      expect(output).to match %r|Removed:\n  GET    /started|
      expect(output).to match %r|Modified:\n  GET    /back|
      expect(output).to match %r|New:\n  GET    /ready|
    end
  end

  context '-R or --removed' do
    it "shows removed routes" do
      Rails.application.routes.draw do
        get :ready, to: 'shine#again'
        get :back, to: 'the#future'
      end

      output = pry_eval('diff-routes -R')

      expect(output).to match %r|Removed:\n  GET    /started|
      expect(output).not_to match %r|Modified:|
      expect(output).not_to match %r|New:|
    end
  end

  context '-M or --modified' do
    it "shows modified routes" do
      Rails.application.routes.draw do
        get :ready, to: 'shine#again'
        get :back, to: 'the#future'
      end

      output = pry_eval('diff-routes -M')

      expect(output).not_to match %r|Removed:|
      expect(output).to match %r|Modified:\n  GET    /back|
      expect(output).not_to match %r|New:|
    end
  end

  context '-N or --new' do
    it "shows new routes" do
      Rails.application.routes.draw do
        get :ready, to: 'shine#again'
        get :back, to: 'the#future'
      end

      output = pry_eval('diff-routes -N')

      expect(output).not_to match %r|Removed:|
      expect(output).not_to match %r|Modified:|
      expect(output).to match %r|New:\n  GET    /ready|
    end
  end

  context '-S or --save' do
    it "saves current routes as the basis for changes" do
      Rails.application.routes.draw do
        get :ready, to: 'shine#again'
        get :back, to: 'the#future'
      end

      pry_eval('diff-routes -S')

      expect(pry_eval('diff-routes')).to match /No routes changed./
    end
  end
end

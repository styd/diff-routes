require 'spec_helper'

Route = -> (*args) {
  Struct.new(:name, :verb, :requirements, :irrelevant) do
    def app; OpenStruct.new(dispatcher?: true) end
    def path; OpenStruct.new(spec: '/path(.:format)') end
    def parts; [] end
  end.new(*args)
}


RSpec.describe PryRailsDiffRoutes::RouteWrapper do
  let(:first) {
    described_class.new(
      Route['prefix', 'GET', {controller: 'c', action: 'a', locale: :id}, :bravo]
    )
  }
  let(:second) {
    described_class.new(
      Route['prefix','GET', {controller: 'c', action: 'a', locale: :en}, :alpha]
    )
  }
  let(:third) {
    described_class.new(
      Route['prefix', 'GET', {controller: 'c', action: 'b', locale: :es}, :sierra]
    )
  }

  describe '#<=> and #eql?' do
    it 'matches routes only based on relevant attributes' do
      second.requirements[:locale] = :id

      expect(first == second).to be true
      expect(first == third).to be false

      expect(first.eql? second).to be true
      expect(first.eql? third).to be false
    end
  end

  describe '#hash' do
    it 'combines hash of relevant attributes only' do
      expect(first.hash).to eq ['prefix', 'GET', "c#a #{{locale: :id}}"].hash
      expect(second.hash).to eq ['prefix', 'GET', "c#a #{{locale: :en}}"].hash
      expect(third.hash).to eq ['prefix', 'GET', "c#b #{{locale: :es}}"].hash
    end
  end

  describe '#to_s' do
    it 'displays the routes changes' do
      expect(first.to_s).to match %r|GET.*-> prefix.*-> CController.*-> #a.*-> {:?locale.*:id}|m
      expect(second.to_s).to match %r|GET.*-> prefix.*-> CController.*-> #a.*-> {:?locale.*:en}|m
      expect(third.to_s).to match %r|GET.*-> prefix.*-> CController.*-> #b.*-> {:?locale.*:es}|m
    end
  end

  describe '#display_verb_and_path' do
    it 'display route verb and path' do
      expect(first.display_verb_and_path).to match %r|GET.*/path.*(.:format)|
      expect(second.display_verb_and_path).to eq first.display_verb_and_path
      expect(third.display_verb_and_path).to eq first.display_verb_and_path
    end
  end

  describe '#display_prefix' do
    it 'display prefix key with the prefix' do
      expect(first.display_prefix).to eq 'Prefix      -> prefix'
      expect(second.display_prefix).to eq first.display_prefix
      expect(third.display_prefix).to eq first.display_prefix
    end
  end

  describe '#display_controller' do
    it 'display controller key with the controller' do
      expect(first.display_controller).to eq 'Controller  -> CController'
      expect(second.display_controller).to eq first.display_controller
      expect(third.display_controller).to eq first.display_controller
    end
  end

  describe '#display_action' do
    it 'display action key with the action' do
      expect(first.display_action).to eq 'Action      -> #a'
      expect(second.display_action).to eq first.display_action
      expect(third.display_action).to eq 'Action      -> #b'
    end
  end

  describe '#display_constraints' do
    it 'display constraints key with the constraints', if: RUBY_ENGINE == 'ruby' do
      expect(first.display_constraints).to eq 'Constraints -> {locale: :id}'
      expect(second.display_constraints).to eq 'Constraints -> {locale: :en}'
      expect(third.display_constraints).to eq 'Constraints -> {locale: :es}'
    end

    it 'display constraints key with the constraints', unless: RUBY_ENGINE == 'ruby' do
      expect(first.display_constraints).to eq 'Constraints -> {:locale=>:id}'
      expect(second.display_constraints).to eq 'Constraints -> {:locale=>:en}'
      expect(third.display_constraints).to eq 'Constraints -> {:locale=>:es}'
    end
  end
end

require 'spec_helper'
# require 'observer'

describe 'Lemmatizer' do
  let(:lem) { Lemmatizer.new }

  context 'simple cases' do
    specify 'it finds the base of a word' do

      expect(lem.lemma('dogs', :noun)).to eq('dog')
      expect(lem.lemma('hired', :verb )).to eq('hire')
      expect(lem.lemma('hotter', :adj )).to eq('hot')
      # expect(lem.lemma("better", :adv )).to eq('good')
      expect(lem.lemma('better', :adv )).to eq('well')

      # when part-of-speech symbol is not specified as the second argument, 
      # lemmatizer tries :verb, :noun, :adj, and :adv one by one in this order.
      expect(lem.lemma('fired')).to eq('fire')
      expect(lem.lemma('slow')).to eq('slow')
    end

    specify 'conjugations' do
      expect(lem.lemma('run', :verb )).to eq('run')
      expect(lem.lemma('runner', :noun )).to eq('runner')
      expect(lem.lemma('running', :verb )).to eq('run')
    end

    specify 'leavin words as the are' do
      expect(lem.lemma('MacBooks', :noun)).to eq('MacBooks')
      expect(lem.lemma('higher', :adj)).to eq('higher')

    end
  end
end

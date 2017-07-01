require 'spec_helper'

describe 'Classifier' do
  context 'simple cases' do
    let(:bayesian) do
      b = Classifier::Bayes.new 'Interesting', 'Uninteresting'
      b.train_interesting "here are some good words. I hope you love them"
      b.train_uninteresting "here are some bad words, I hate you"
      b
    end
    
    specify 'it trains what is interesting and what it is not.' do
      expect(bayesian.classify "I hate bad words and you").to eq('Uninteresting')
      expect(bayesian.classify "I love you").to eq('Interesting')
      expect(bayesian.classify "I like you").to eq('Interesting')
      expect(bayesian.classify "I don't like you").to eq('Uninteresting')
      expect(bayesian.classify "fuck").to eq('Uninteresting')
      expect(bayesian.classify "good").to eq('Interesting')
    end
  end
end

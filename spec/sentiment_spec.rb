require 'spec_helper'

describe 'Sentiment' do
  let(:analyzer) { SentimentLib::Analyzer.new }

  context 'simple cases' do
    specify 'it finds the base of a word' do
      expect(analyzer.analyze("I'm feeling confident and excited this morning!")).to be >= 2
      expect(analyzer.analyze("I'm feeling bad killed and depressed")).to be < 0
      expect(analyzer.analyze("I'm feeling blue")).to eq(0)
    end
  end
end

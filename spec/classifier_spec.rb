require 'spec_helper'

describe 'Classifier' do
  context 'Latent Semantic Indexer' do
    let(:lsi) { lsi = Classifier::LSI.new }

    specify 'It learns the tags more easily' do
      strings = [ ["This text deals with dogs. Dogs.", :dog],
                  ["This text involves dogs too. Dogs! ", :dog],
                  ["This text revolves around cats. Cats.", :cat],
                  ["This text also involves cats. Cats!", :cat],
                  ["This text involves birds. Birds.",:bird ] ]
      strings.each { |x| lsi.add_item x.first, x.last }
      
      expect(lsi.search("dog", 3)).to eq(["This text deals with dogs. Dogs.", "This text involves dogs too. Dogs! ", "This text also involves cats. Cats!"])
      expect(lsi.find_related(strings[2], 2)).to eq(["This text revolves around cats. Cats.", "This text also involves cats. Cats!"])

      expect(lsi.classify "This text is also about dogs!").to eq(:dog)
      expect(lsi.classify "Dogs are humans friends!").to eq(:dog)
      expect(lsi.classify "Cats eats mices").to eq(:cat)

      expect(lsi.find_related "Cats eats mices").to eq(["This text also involves cats. Cats!", "This text revolves around cats. Cats.", "This text involves dogs too. Dogs! "])
    end

    specify 'More that one aspect + learning' do
      strings = [ ["I love dogs", [:dog, :love, :positive]],
                  ["This text involves dogs", [:dog, :text]],
                  ["I love cats", [:cat, :love, :positive]],
                  ["I love cars", [:car, :love, :positive]],
                  ["I hate cats in the car I love", [:cat, :car, :negative]]
                  # ["I hate dogs in the car I love", [:dog, :car, :negative]]
                ]
      strings.each {|x| lsi.add_item x.first, x.last}

      expect(lsi.classify "Dogs are humans friends!").to eq([:dog, :love, :positive])
      # expect(lsi.classify "Dogs love cars!").to eq([:dog, :car, :positive])
      expect(lsi.classify "Dogs love cars!").to eq([:car, :love, :positive])
      expect(lsi.classify "Dogs hate cats!").to_not eq([:dog, :cat, :negative])
      expect(lsi.classify "Dogs hate cats!").to eq([:cat, :love, :positive])
      lsi.add_item "Dogs hate cats!", [:dog, :cat, :negative]
      expect(lsi.classify "Dogs hate cats!").to_not eq([:cat, :love, :positive])
      expect(lsi.classify "Dogs hate cats!").to eq([:dog, :cat, :negative])

      expect(lsi.classify "I love beautifull and disciplined dogs").to eq([:dog, :love, :positive])
    end
  end

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

    context 'Madelaine' do
      require 'madeleine'

      specify 'simple cases' do
        m = SnapshotMadeleine.new("bayes_data") {
            Classifier::Bayes.new 'Interesting', 'Uninteresting'
        }
        m.system.train_interesting "here are some good words. I hope you love them"
        m.system.train_uninteresting "here are some bad words, I hate you"
        m.take_snapshot

        expect(m.system.classify "I hate bad words and you").to eq('Uninteresting')
        expect(m.system.classify "I love you").to eq('Interesting')
        expect(m.system.classify "I like you").to eq('Interesting')
        expect(m.system.classify "I don't like you").to eq('Uninteresting')
        expect(m.system.classify "fuck").to eq('Uninteresting')
        expect(m.system.classify "good").to eq('Interesting')
      end
    end
  end
end

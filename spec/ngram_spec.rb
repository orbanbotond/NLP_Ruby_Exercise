require 'spec_helper'

describe 'Ngrammer' do
  let(:data) { ['Here it is some text', 'And here is again'] }
  let(:ngram) { NGram.new(data, :n => [2,3,4]) }

  context 'simple cases' do
    specify 'it finds the base of a word' do
      expect(ngram.ngrams_of_all_data[2].keys.map{|x|x.split(' ').size}.all?{|x|x==2}).to be_truthy
      expect(ngram.ngrams_of_all_data[3].keys.map{|x|x.split(' ').size}.all?{|x|x==3}).to be_truthy
      expect(ngram.ngrams_of_all_data[2].keys).to eq(["Here it", "it is", "is some", "some text", "And here", "here is", "is again"])
    end
  end
end

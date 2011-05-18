require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe FamilyReunion::FuzzyMatcher do
  before(:all) do
    @fr = FamilyReunion.new(FamilyReunion::Spec::Config.ants_primary_node, FamilyReunion::Spec::Config.ants_secondary_node)
    @fm = FamilyReunion::FuzzyMatcher.new(@fr)
  end

  describe '::are_similar_words' do

    it "should get similar words" do
      [ 'Gorilla Garella', 'balleion follien', 'jamanara anjaras', 'copper rapper', 'Boloan Soloan'].each do |words|
        words = words.split ' '
        FuzzyMatcher.are_similar_words(words[0], words[1]).should be_true
      end
    end
  end
end

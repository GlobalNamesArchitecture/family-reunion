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

__END__
  def get_synonym_fuzzy_matches
    @valid_to_syn_fuzzy_matches = @primary_valid_names_set.inject({}) {|res, n| res[n] = @fuzzy_matcher.match_synonym_names(n); res}.select {|key, value| value != nil}
    @syn_to_valid_fuzzy_matches = @primary_synonyms_set.inject({}) {|res, n| res[n] = @fuzzy_matcher.match_valid_names(n); res}.select {|key, value| value != nil}
    @syn_to_syn_fuzzy_matches = @primary_synonyms_set.inject({}) {|res, n| res[n] = @fuzzy_matcher.match_synonym_names(n); res}.select {|key, value| value != nil}
    format_fuzzy_matches(@valid_to_syn_fuzzy_matches) 
    format_fuzzy_matches(@syn_to_valid_fuzzy_matches) 
    format_fuzzy_matches(@syn_to_syn_fuzzy_matches) 
  end

  def get_valid_fuzzy_matches
    @valid_to_valid_fuzzy_matches = @primary_valid_names_set.inject({}) {|res, n| res[n] = @fuzzy_matcher.match_valid_names(n); res}.select {|key, value| value != nil}
    format_fuzzy_matches(@valid_to_valid_fuzzy_matches) 
  end
  
  def fuzzy_match_leaves
    get_valid_fuzzy_matches
    get_synonym_fuzzy_matches
  end




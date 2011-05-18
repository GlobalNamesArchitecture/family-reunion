require 'json'
require 'taxamatch_rb'
require 'family-reunion/node'
require 'family-reunion/fuzzy_matcher'


class FamilyReunion
  attr :primary_node, :secondary_node, :matched_secondary_ids

  def initialize(primary_node, secondary_node)
    @primary_node = FamilyReunion::Node.new(primary_node)
    @secondary_node = FamilyReunion::Node.new(secondary_node)
    @merges = {}
    @empty_nodes = {}
    @valid_matches = nil
    @imperfect_matches = nil
    @matched_secondary_ids = []
  end

  def merge(with_fuzzy_matching = true)
    match_leaves
    if with_fuzzy_matching
      @fuzzy_matcher = FamilyReunion::FuzzyMatcher.new(self)
      fuzzy_match_leaves 
    end
    @merges 
  end

  def all_names_sets
    primary_names = @primary_valid_names_set | @primary_synonyms_set
    secondary_names = @secondary_valid_names_set | @secondary_synonyms_set
    [primary_names, secondary_names]
  end

  private

  def match_leaves
    prepare_data_for_valid_match
    get_valid_matches
    prepare_data_for_synonym_match
    get_synonym_matches
  end

  def fuzzy_match_leaves
    get_valid_fuzzy_matches
    get_synonym_fuzzy_matches
  end

  def prepare_data_for_valid_match
    @primary_valid_names_set = Set.new(@primary_node.valid_names_hash.keys)
    @secondary_valid_names_set = Set.new(@secondary_node.valid_names_hash.keys)
    @valid_matches = @primary_valid_names_set & @secondary_valid_names_set
  end

  def prepare_data_for_synonym_match
    @primary_residuals = @primary_valid_names_set - @valid_matches
    @secondary_residuals = @secondary_valid_names_set - @valid_matches
    @primary_synonyms_set = Set.new(@primary_node.synonyms_hash.keys)
    @secondary_synonyms_set = Set.new(@secondary_node.synonyms_hash.keys)

    @valid_to_syn_matches = @primary_valid_names_set & @secondary_synonyms_set
    @syn_to_valid_matches = @primary_synonyms_set & @secondary_valid_names_set
    @syn_to_syn_matches = @primary_synonyms_set & @secondary_synonyms_set
  end

  def get_valid_fuzzy_matches
    @valid_to_valid_fuzzy_matches = @primary_valid_names_set.inject({}) {|res, n| res[n] = @fuzzy_matcher.match_valid_names(n); res}.select {|key, value| value != nil}
    format_fuzzy_matches(@valid_to_valid_fuzzy_matches) 
  end

  def get_synonym_fuzzy_matches
    @valid_to_syn_fuzzy_matches = @primary_valid_names_set.inject({}) {|res, n| res[n] = @fuzzy_matcher.match_synonym_names(n); res}.select {|key, value| value != nil}
    @syn_to_valid_fuzzy_matches = @primary_synonyms_set.inject({}) {|res, n| res[n] = @fuzzy_matcher.match_valid_names(n); res}.select {|key, value| value != nil}
    @syn_to_syn_fuzzy_matches = @primary_synonyms_set.inject({}) {|res, n| res[n] = @fuzzy_matcher.match_synonym_names(n); res}.select {|key, value| value != nil}
    format_fuzzy_matches(@valid_to_syn_fuzzy_matches) 
    format_fuzzy_matches(@syn_to_valid_fuzzy_matches) 
    format_fuzzy_matches(@syn_to_syn_fuzzy_matches) 
  end

  def format_fuzzy_matches(matches_hash)
  end


  def get_valid_matches
    @valid_matches.each do |name|
      primary_id = @primary_node.valid_names_hash[name][:id]
      secondary_id = @secondary_node.valid_names_hash[name][:id]
      @matched_secondary_ids << secondary_id
      @merges[primary_id] = {:matches => {secondary_id.to_s => {:match_type => :valid_to_valid}}, :children => []}
    end
  end

  def get_synonym_matches
     format_synonym_matches(@valid_to_syn_matches, :valid_to_synonym)
     format_synonym_matches(@syn_to_valid_matches, :synonym_to_valid)
     format_synonym_matches(@syn_to_syn_matches, :synonym_to_synonym)
  end
 
  def format_synonym_matches(matches_set, match_type)
    matches_set.each do |name|
      primary_ids = get_ids_by_synonym(name, @primary_node.valid_names_hash, @primary_node.synonyms_hash)
      secondary_ids = get_ids_by_synonym(name, @secondary_node.valid_names_hash, @secondary_node.synonyms_hash)
      @matched_secondary_ids += secondary_ids

      secondary_id_matches = secondary_ids.inject({}) do |res, i| 
        i = i.to_s
        res[i] = {:match_type => match_type} unless res.has_key?(i)
        res
      end
      
      primary_ids.each do |primary_id|
        if @merges.has_key?(primary_id)
          secondary_id_matches.each do |key, val|
            @merges[primary_id][:matches][key] = val unless @merges[primary_id][:matches].has_key?(key)
          end
        else 
          @merges[primary_id] = {:matches => secondary_id_matches, :children => []} 
        end
      end

    end
  end

  def get_ids_by_synonym(name, valid_names, synonyms)
    res = []
    if valid_names.has_key?(name)
      res << valid_names[name][:id]
    else
      res = synonyms[name].map {|n| n[:id]}
    end
    res
  end

end

require 'json'
require 'taxamatch_rb'
require 'family-reunion/cache'
require 'family-reunion/top_node'
require 'family-reunion/matcher_helper'
require 'family-reunion/exact_matcher'
require 'family-reunion/fuzzy_matcher'
require 'family-reunion/taxamatch_wrapper'
require 'family-reunion/taxamatch_preprocessor'
require 'family-reunion/nomatch_organizer'


class FamilyReunion
  attr :primary_node, :secondary_node, :merges
  attr :primary_valid_names_set, :secondary_valid_names_set
  attr :primary_synonyms_set, :secondary_synonyms_set

  def initialize(primary_node, secondary_node)
    @primary_node = FamilyReunion::TopNode.new(primary_node)
    @secondary_node = FamilyReunion::TopNode.new(secondary_node)
    @primary_valid_names_set = Set.new(@primary_node.valid_names_hash.keys)
    @secondary_valid_names_set = Set.new(@secondary_node.valid_names_hash.keys)
    @primary_synonyms_set = Set.new(@primary_node.synonyms_hash.keys)
    @secondary_synonyms_set = Set.new(@secondary_node.synonyms_hash.keys)
    @merges = {}
  end

  def merge(with_fuzzy_matching = true)
    merge_exact_matches
    merge_fuzzy_matches if with_fuzzy_matching
    merge_no_matches
    @merges
  end

  private

  def merge_exact_matches
    ExactMatcher.new(self).merge
  end

  def merge_fuzzy_matches
    FuzzyMatcher.new(self).merge
  end
  
  def merge_no_matches
    NomatchOrganizer.new(self).merge
  end

end

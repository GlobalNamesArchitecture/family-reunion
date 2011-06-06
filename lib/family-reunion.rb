require 'json'
require 'taxamatch_rb'
require 'family-reunion/cache'
require 'family-reunion/node'
require 'family-reunion/exact_matcher'
require 'family-reunion/fuzzy_matcher'
require 'family-reunion/taxamatch_wrapper'
require 'family-reunion/taxamatch_preprocessor'


class FamilyReunion
  attr :primary_node, :secondary_node, :merges
  attr :primary_valid_names_set, :secondary_valid_names_set
  attr :primary_synonyms_set, :secondary_synonyms_set

  def initialize(primary_node, secondary_node)
    @primary_node = FamilyReunion::Node.new(primary_node)
    @secondary_node = FamilyReunion::Node.new(secondary_node)
    @primary_valid_names_set = Set.new(@primary_node.valid_names_hash.keys)
    @secondary_valid_names_set = Set.new(@secondary_node.valid_names_hash.keys)
    @primary_synonyms_set = Set.new(@primary_node.synonyms_hash.keys)
    @secondary_synonyms_set = Set.new(@secondary_node.synonyms_hash.keys)
    @merges = {}
  end

  def merge(with_fuzzy_matching = true)
    merge_exact_matches
    merge_fuzzy_matches if with_fuzzy_matching
    add_nonmatched_nodes(get_nonmatched_secondary_ids)
    @merges
  end

  private

  def get_nonmatched_secondary_ids
  end

  def merge_exact_matches
    unmatched_names = ExactMatcher.new(self).merge
    unmatched_names
  end

  def merge_fuzzy_matches
    unmatched_names = FuzzyMatcher.new(self).merge
    unmatched_names
  end

  def add_nonmatched_nodes(unmatched_names)
  end

end

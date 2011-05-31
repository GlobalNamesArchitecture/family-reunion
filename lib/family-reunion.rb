require 'json'
require 'taxamatch_rb'
require 'family-reunion/node'
require 'family-reunion/exact_matcher'
require 'family-reunion/fuzzy_matcher'


class FamilyReunion
  attr :primary_node, :secondary_node, :merges
  attr :primary_valid_names_set, :secondary_valid_names_set

  def initialize(primary_node, secondary_node)
    @primary_node = FamilyReunion::Node.new(primary_node)
    @secondary_node = FamilyReunion::Node.new(secondary_node)
    @primary_valid_names_set = Set.new(@primary_node.valid_names_hash.keys)
    @secondary_valid_names_set = Set.new(@secondary_node.valid_names_hash.keys)
    @merges = {}
  end

  def merge(with_fuzzy_matching = true)
    matched_secondary_ids = merge_exact_matches
    nonmatched_secondary_ids = merge_fuzzy_matches(matched_secondary_ids) if with_fuzzy_matching
    add_nonmatched_nodes(nonmatched_secondary_ids)
    @merges
  end

  private

  def merge_exact_matches
    unmatched_names = ExactMatcher.new(self).merge
    unmatched_names
  end

  def merge_fuzzy_matches(unmatched_names)
    # unmatched_names = FuzzyMatcher.new(self, matched_secondary_ids).merge
    # unmatched_names
  end
  
  def add_nonmatched_nodes(unmatched_names)
  end

end

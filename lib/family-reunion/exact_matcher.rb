class FamilyReunion
  class ExactMatcher
    include MatcherHelper

    def initialize(family_reunion)
      @fr = family_reunion
    end

    def merge
      valid_matches = get_valid_matches
      add_valid_matches(valid_matches)
      synonym_matches = get_synonym_matches
      add_synonym_matches(synonym_matches)
    end

    private

    def get_valid_matches
      valid_matches = @fr.primary_valid_names_set & @fr.secondary_valid_names_set
    end

    def add_valid_matches(valid_matches)
      # Homonyms are treated separately, and are not matched by the algorithm,
      # they are excluded from valid_matches
      valid_matches.each do |name|
        primary_id = @fr.primary_node.valid_names_hash[name][:id]
        secondary_id = @fr.secondary_node.valid_names_hash[name][:id]
        @fr.merges[primary_id] = {:matches => {secondary_id.to_s => {:match_type => :valid_to_valid}}, :nonmatches => []}
      end
    end

    def get_synonym_matches
      primary_synonyms_set = Set.new(@fr.primary_node.synonyms_hash.keys)
      secondary_synonyms_set = Set.new(@fr.secondary_node.synonyms_hash.keys)
      res = {}
      res[:valid_to_synonym] = @fr.primary_valid_names_set & @fr.secondary_synonyms_set
      res[:synonym_to_valid] = @fr.primary_synonyms_set & @fr.secondary_valid_names_set
      res[:synonym_to_synonym] = @fr.primary_synonyms_set & @fr.secondary_synonyms_set
      res
    end

    def add_synonym_matches(matches)
      matches.each do |match_type, match_set|
        format_synonym_matches(match_set, match_type)
      end
    end

    def format_synonym_matches(match_set, match_type)
      match_set.each do |name|
        primary_ids, secondary_ids = get_valid_name_ids(name)
        secondary_id_matches = format_secondary_id_matches(secondary_ids, match_type)
        primary_ids.each do |primary_id|
          add_record_to_merges(primary_id, secondary_id_matches)
        end
      end
    end

    def get_valid_name_ids(name)
      primary_ids = get_ids_from_node(name, @fr.primary_node)
      secondary_ids = get_ids_from_node(name, @fr.secondary_node)
      [primary_ids, secondary_ids]
    end

    def get_ids_from_node(name, node)
      valid_names = node.valid_names_hash
      synonyms = node.synonyms_hash
      if valid_names.has_key?(name)
        return [valid_names[name][:id]]
      else
        return synonyms[name].map {|n| n[:id]}
      end
    end

  end
end


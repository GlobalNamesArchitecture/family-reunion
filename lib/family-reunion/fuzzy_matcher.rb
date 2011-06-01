class FamilyReunion
  class FuzzyMatcher
    def initialize(family_reunion, secondary_nonmatched_ids = [])
      @fr = family_reunion
      @tw = FamilyReunion::TaxamatchWrapper.new
    end

    def merge
      valid_matches = get_valid_matches
      add_valid_matches(valid_matches)
    end

    private

    def get_valid_matches
      primary_names = @fr.primary_valid_names_set - @fr.secondary_valid_names_set
      secondary_names = @fr.secondary_valid_names_set - @fr.primary_valid_names_set
      valid_canonical_matches = @tw.match_canonicals_lists(primary_names, secondary_names)
      match_nodes_candidates = get_nodes_from_valid_canonicals(valid_canonical_matches)
      @tw.match_nodes(match_nodes_candidates)
    end

    def get_nodes_from_valid_canonicals(canonical_matches)
      res = []
      canonical_matches.each do |primary_name, secondary_names|
        primary_node = @fr.primary_node.valid_names_hash[primary_name]
        secondary_nodes = secondary_names.map do |secondary_name|
          @fr.secondary_node.valid_names_hash[secondary_name]
        end
        res << [primary_node, secondary_nodes]
      end
      res
    end
      

    end
    
  end
end

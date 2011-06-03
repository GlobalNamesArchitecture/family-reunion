class FamilyReunion
  class FuzzyMatcher
    def initialize(family_reunion, secondary_nonmatched_ids = [])
      @fr = family_reunion
      @tw = FamilyReunion::TaxamatchWrapper.new
    end

    def merge
      valid_matches = get_valid_matches
      #add_valid_matches(valid_matches)
    end

    def get_valid_matches
      primary_names = @fr.primary_valid_names_set - @fr.secondary_valid_names_set
      secondary_names = @fr.secondary_valid_names_set - @fr.primary_valid_names_set
      canonical_matches = @tw.match_canonicals_lists(primary_names, secondary_names)
      match_nodes_candidates = get_nodes_from_canonicals(canonical_matches, :valid_name, :valid_name)
      @tw.match_nodes(match_nodes_candidates)
    end

    def get_valid_to_synonym_matches
      primary_names = @fr.primary_valid_names_set - @fr.secondary_synonyms_set
      secondary_names = @fr.secondary_synonyms_set - @fr.primary_valid_names_set
      canonical_matches = @tw.match_canonicals_lists(primary_names, secondary_names)
      match_nodes_candidates = get_nodes_from_canonicals(canonical_matches, :valid_name, :synonym)
      @tw.match_nodes(match_nodes_candidates)
    end

    def get_synonym_to_valid_matches
      primary_names = @fr.primary_synonyms_set - @fr.secondary_valid_names_set
      secondary_names = @fr.secondary_valid_names_set - @fr.primary_synonyms_set
      canonical_matches = @tw.match_canonicals_lists(primary_names, secondary_names)
      match_nodes_candidates = get_nodes_from_canonicals(canonical_matches, :synonym, :valid_name)
      @tw.match_nodes(match_nodes_candidates)
    end

    def get_synonym_to_synonym_matches
      primary_names = @fr.primary_synonyms_set - @fr.secondary_synonyms_set
      secondary_names = @fr.secondary_synonyms_set - @fr.primary_synonyms_set
      canonical_matches = @tw.match_canonicals_lists(primary_names, secondary_names)
      match_nodes_candidates = get_nodes_from_canonicals(canonical_matches, :synonym, :synonym)
      @tw.match_nodes(match_nodes_candidates)
    end

    private

    def get_nodes_from_canonicals(canonical_matches, primary_name_type, secondary_name_type)
      res = []
      canonical_matches.each do |primary_name, secondary_names|
        primary_nodes = self.send("get_#{primary_name_type}_node", @fr.primary_node, primary_name)
        secondary_nodes = secondary_names.map do |secondary_name|
          self.send("get_#{secondary_name_type}_node", @fr.secondary_node, secondary_name)
        end
        append_nodes(res, primary_nodes, secondary_nodes)
      end
      res
    end

    def append_nodes(nodes, primary_nodes, secondary_nodes)
      secondary_nodes = secondary_nodes.flatten.uniq
      primary_nodes.each do |primary_node|
        nodes << [primary_node, secondary_nodes]
      end
    end

    def get_valid_name_node(root_node, name)
      node = root_node.valid_names_hash[name]
      node.merge!({ :name_to_match => node[:valid_name][:name] })
      [node]
    end

    def get_synonym_node(root_node, name)
      nodes = root_node.synonyms_hash[name]
      nodes.each do |n|
        synonym_name = n[:synonyms].select { |s| s[:canonical_name] == name }.first[:name]
        n.merge!({ :name_to_match => synonym_name })
      end
    end

  end
end

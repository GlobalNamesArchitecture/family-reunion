class FamilyReunion
  class NomatchOrganizer

    def initialize(family_reunion)
      @fr = family_reunion
      @nomatch_secondary_ids = nil
    end

    def merge
      FamilyReunion.logger_write(@fr.object_id, "Filling gaps with new taxa")
      organize_nonmatches(get_nomach_secondary_ids)
    end

    def get_nomach_secondary_ids
      return @nomatch_secondary_ids if @nomatch_secondary_ids
      match_ids = @fr.merges.map { |key, val| val[:matches].keys }.flatten.uniq
      empty_nodes_ids =  @fr.secondary_node.data[:empty_nodes].map { |node| node[:id].to_s.to_sym }
      valid_names_ids = @fr.secondary_node.ids_hash.keys.map { |k| k }
      @nomatch_secondary_ids = valid_names_ids - match_ids
    end

    def organize_nonmatches(nomatch_secondary_ids)
      ids_hash = @fr.secondary_node.ids_hash
      paths_hash = @fr.primary_node.paths_hash
      nomatch_secondary_ids.each do |i|
        node = ids_hash[i]
        merge_node(node, paths_hash)
      end
    end

    private

    def merge_node(node, paths_hash)
      path = node[:path].dup
      last_name = path.pop.to_sym
      return if paths_hash.has_key?(last_name)
      found_node = false
      until path.empty?
        name = path.pop.to_sym
        if paths_hash.has_key?(name)
          found_node = true
          add_merged_node(paths_hash[name][1][-1], node[:id].to_s.to_sym)
          break
        end
      end
      add_merged_node(@fr.primary_node.root_id, node[:id].to_s.to_sym) unless found_node
    end

    def add_merged_node(primary_node_id, secondary_node_id)
      secondary_node_id = secondary_node_id.to_s.to_sym
      path = @fr.secondary_node.ids_hash[secondary_node_id][:path]
      path_ids = @fr.secondary_node.ids_hash[secondary_node_id][:path_ids]
      if @fr.merges.has_key?(primary_node_id) #never happens?
        @fr.merges[primary_node_id][:nonmatches][secondary_node_id] = { :match_type => "new", :path => path, :path_ids => path_ids }
      else
        @fr.merges[primary_node_id] = { :matches => {}, :nonmatches => {secondary_node_id => { :match_type => nil, :path => path, :path_ids => path_ids } } }
      end
    end

  end
end

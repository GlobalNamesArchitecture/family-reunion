#!/usr/bin/env ruby
require "dwc-archive"

class Node
  attr_reader :classification

  def logger
    @logger || Logger.new($stdout)
  end

  def initialize(dwca_file)
    @dwca = DarwinCore.new(dwca_file)
    DarwinCore.logger = logger
    logger.info("Creating classification tree")
    @classification = DarwinCore::ClassificationNormalizer.new(@dwca)
    @classification.normalize
    @leaves = []
  end

  def leaves(node_id)
    node = @classification.normalized_data[node_id]
    path = node.classification_path_id
    @node_path_size = path.size - 1
    current_node = @classification.tree
    until path.empty? do
      current_node = current_node[path.shift]
    end
    walk_tree(current_node)
    @leaves
  end

  private

  def walk_tree(current_node, active_leaf = nil, depth = 0)
    current_node.keys.each do |key|
      get_data(key)
      walk_tree(current_node[key])
    end
  end

  def get_data(node_id)
    node = @classification.normalized_data[node_id]
    if is_species?(node.current_name_canonical)
      current_path_size = node.classification_path.size
      names =  [{:name => node.current_name, :canonical_name => node.current_name_canonical, :type => :current, :status => node.status}]
      node.synonyms.each do |syn|
        names << {:name => syn.name, :canonical_name => syn.canonical_name, :type => :synonym, :status => syn.status}
      end
      if is_species?(node.classification_path[-2])
        @leaves.last[:names] += names
      else
        res = {:path => node.classification_path[@node_path_size..current_path_size], :path_ids => node.classification_path_id[@node_path_size..current_path_size], :names => names}
        @leaves << res
      end
    end
  end

  def is_species?(name_string)
    name_string.split(/\s+/).size >=2
  end

end

#
# n = Node.new(db, paths_file)
# leaves = n.leaves node_id
#
if __FILE__ == $0

  unless ARGV[1]
    puts "script creates a json file with data compatible for family-reunion from a darwin core archive"
    puts "Usage #{$0} path_to_dwca_file node_id [output_file]"
    puts "output_file is optional"
    exit
  end

  dwca_file = ARGV[0]
  node_id = ARGV[1]
  paths_file = ARGV[2] ? ARGV[2] : "node_leaves.json"

  n = Node.new(dwca_file)
  l = n.leaves(node_id)
  names = l.map {|n| n[:names].map {|nn| nn[:name]}}
  require 'ruby-debug'; debugger
  puts ''


end

require 'json'
require 'family-reunion/node'


class FamilyReunion
  attr :primary_node, :secondary_node

  def initialize(primary_node, secondary_node)
    @primary_node = FamilyReunion::Node.new(primary_node)
    @secondary_node = FamilyReunion::Node.new(secondary_node)
    @merges = {}
    @empty_nodes = {}
  end

  def merge
    match_leaves
    @merges 
  end

  private

  def match_leaves
    get_perfect_matches
  

  end

  def get_perfect_matches
    t = Time.now
    pcn_hash = @primary_node.current_names_hash
    puts Time.now - t
    scn_hash = @secondary_node.current_names_hash
    puts Time.now - t
    crossection = (Set.new(pcn_hash.keys) & Set.new(scn_hash.keys))
    crossection.each do |name|
      primary_id = pcn_hash[name][:id]
      secondary_id = scn_hash[name][:id]
      @merges[primary_id] = {:match => secondary_id, :children => []}
    end
  end
end

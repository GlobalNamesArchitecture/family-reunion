require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe FamilyReunion do
  before(:all) do
    @fr = FamilyReunion.new(@ants_primary_node, @ants_secondary_node)
  end

  it "should merge" do
    merges, empty_nodes = @fr.merge
  end
end

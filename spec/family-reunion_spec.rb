require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe FamilyReunion do
  before(:all) do
    @fr = FamilyReunion.new(FamilyReunion::Spec::Config.ants_primary_node, FamilyReunion::Spec::Config.ants_secondary_node)
  end

  it "should generate instances of nodes" do
    @fr.primary_node.is_a?(FamilyReunion::Node).should be_true
    @fr.secondary_node.is_a?(FamilyReunion::Node).should be_true
  end

  it "should merge" do
    require 'ruby-debug'; debugger
    merges = @fr.merge
    merges.is_a?(Hash).should be_true
    merges.size.should > 0
    require 'ruby-debug'; debugger
    puts ''
  end
end

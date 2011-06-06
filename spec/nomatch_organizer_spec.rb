require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe FamilyReunion::NomatchOrganizer do
  before(:all) do
    @conf = FamilyReunion::Spec::Config
    @fr = FamilyReunion.new(@conf.ants_primary_node, @conf.ants_secondary_node)
    @no = FamilyReunion::NomatchOrganizer.new(@fr)
    @fr.stubs(:merges => @conf.matched_merges)
  end

  it "should find nonmatched secondary nodes" do
    nomatch_secondary_ids = @no.get_nomach_secondary_ids
  end
end

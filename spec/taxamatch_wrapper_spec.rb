require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe FamilyReunion::FuzzyMatcher do
  before(:all) do
    @conf = FamilyReunion::Spec::Config
    @tw = FamilyReunion::TaxamatchWrapper.new
    @primary_valid_names = @conf.valid_names_primary - @conf.valid_names_secondary
    @secondary_valid_names = @conf.valid_names_secondary - @conf.valid_names_primary 
  end

  it "should be able to match lists of canonical names" do
    @tw.match_canonicals_lists(@primary_valid_names, @secondary_valid_names)
  end

end

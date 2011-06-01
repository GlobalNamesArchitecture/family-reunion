require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe FamilyReunion::FuzzyMatcher do
  before(:all) do
    @conf = FamilyReunion::Spec::Config
    @tw = FamilyReunion::TaxamatchWrapper.new
  end

  it "should be able to match lists of canonical names" do
    @tw.match_canonicals_lists(@conf.valid_names_primary, @conf.valid_names_secondary)
  end

end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe FamilyReunion::FuzzyMatcher do
  before(:all) do
    @conf = FamilyReunion::Spec::Config
    @fr = FamilyReunion.new(@conf.ants_primary_node, @conf.ants_secondary_node)
    @fm = FamilyReunion::FuzzyMatcher.new(@fr)
  end

  it "should be able to match valid names" do
    @fm.get_valid_matches.should == [[{:id=>"invasiveants:tid:1453", :path=>["Formicidae", "Pachycondlya", "Pachycondlya solitaria"], :path_ids=>["invasiveants:tid:1381", "invasiveants:tid:1452", "invasiveants:tid:1453"], :rank=>"species", :valid_name=>{:name=>"Pachycondlya solitaria (Smith, F. 1860)", :canonical_name=>"Pachycondlya solitaria", :type=>"valid", :status=>nil}, :synonyms=>[], :name_to_match=>"Pachycondlya solitaria (Smith, F. 1860)"}, [{:id=>"hex10354887", :path=>["Formicidae", "Pachycondyla", "Pachycondyla solitaria"], :path_ids=>["hex100521", "hex1022882", "hex10354887"], :rank=>"species", :valid_name=>{:name=>"Pachycondyla solitaria (Smith, 1860)", :canonical_name=>"Pachycondyla solitaria", :type=>"valid", :status=>"accepted"}, :synonyms=>[], :name_to_match=>"Pachycondyla solitaria (Smith, 1860)"}]]]
  end

  it "should be able to match valid names to synonyms" do
    @fm.get_valid_to_synonym_matches.should == [[{:id=>"invasiveants:tid:1407", :path=>["Formicidae", "Crematogaster", "Crematogaster obscurata"], :path_ids=>["invasiveants:tid:1381", "invasiveants:tid:1406", "invasiveants:tid:1407"], :rank=>"species", :valid_name=>{:name=>"Crematogaster obscurata  Emery, 1895", :canonical_name=>"Crematogaster obscurata", :type=>"valid", :status=>nil}, :synonyms=>[{:name=>"Nothosphinctus sillaceus Clark 2010", :canonical_name=>"Nothosphinctus sillaceus", :type=>"synonym", :status=>"synonym"}, {:name=>"Crematogaster agnita Wheeler, W.M. 1934", :canonical_name=>"Crematogaster agnita", :type=>"synonym", :status=>"synonym"}], :name_to_match=>"Crematogaster obscurata  Emery, 1895"}, [{:id=>"hex10758181", :path=>["Formicidae", "Trapeziopelta", "Trapeziopelta diadela"], :path_ids=>["hex100521", "hex1057748", "hex10758181"], :rank=>"species", :valid_name=>{:name=>"Trapeziopelta diadela Clark, 1934", :canonical_name=>"Trapeziopelta diadela", :type=>"valid", :status=>nil}, :synonyms=>[{:name=>"Crematogaster obscurat Emery, 1895", :canonical_name=>"Crematogaster obscurat", :type=>"synonym", :status=>"synonym"}], :name_to_match=>"Crematogaster obscurat Emery, 1895"}]]]
  end

  it "should be able to match synonyms to valid names" do
    @fm.get_synonym_to_valid_matches.should == [[{:id=>"invasiveants:tid:1407", :path=>["Formicidae", "Crematogaster", "Crematogaster obscurata"], :path_ids=>["invasiveants:tid:1381", "invasiveants:tid:1406", "invasiveants:tid:1407"], :rank=>"species", :valid_name=>{:name=>"Crematogaster obscurata  Emery, 1895", :canonical_name=>"Crematogaster obscurata", :type=>"valid", :status=>nil}, :synonyms=>[{:name=>"Nothosphinctus sillaceus Clark 2010", :canonical_name=>"Nothosphinctus sillaceus", :type=>"synonym", :status=>"synonym"}, {:name=>"Crematogaster agnita Wheeler, W.M. 1934", :canonical_name=>"Crematogaster agnita", :type=>"synonym", :status=>"synonym"}], :name_to_match=>"Nothosphinctus sillaceus Clark 2010"}, [{:id=>"hex10758108", :path=>["Formicidae", "Nothosphinctus", "Nothosphinctus silaceus"], :path_ids=>["hex100521", "hex1057733", "hex10758108"], :rank=>"species", :valid_name=>{:name=>"Nothosphinctus silaceus Clark", :canonical_name=>"Nothosphinctus silaceus", :type=>"valid", :status=>nil}, :synonyms=>[], :name_to_match=>"Nothosphinctus silaceus Clark"}]]]
  end

  it "should be able to match synonyms to synonyms" do
    @fm.get_synonym_to_synonym_matches.should == [[{:id=>"invasiveants:tid:1397", :path=>["Formicidae", "Camponotus", "Camponotus sexguttatus"], :path_ids=>["invasiveants:tid:1381", "invasiveants:tid:1393", "invasiveants:tid:1397"], :rank=>"species", :valid_name=>{:name=>"Camponotus sexguttatus (Fabricius, 1793)", :canonical_name=>"Camponotus sexguttatus", :type=>"valid", :status=>nil}, :synonyms=>[{:name=>"Formica albofasciata Smith, F., 1862", :canonical_name=>"Formica albofasciata", :type=>"synonym", :status=>"synonym"}, {:name=>"Formica bimaculata Smith, F., 1858", :canonical_name=>"Formica bimaculata", :type=>"synonym", :status=>"synonym"}, {:name=>"Formica ruficeps Smith, F., 1804", :canonical_name=>"Formica ruficeps", :type=>"synonym", :status=>"synonym"}], :name_to_match=>"Formica ruficeps Smith, F., 1804"}, [{:id=>"hex10357934", :path=>["Formicidae", "Formica", "Formica lavateri"], :path_ids=>["hex100521", "hex1023020", "hex10357934"], :rank=>"species", :valid_name=>{:name=>"Formica lavateri Heer, 1850", :canonical_name=>"Formica lavateri", :type=>"valid", :status=>"accepted"}, :synonyms=>[{:name=>"Formida ruficeps Smith, F., 1804", :canonical_name=>"Formida ruficeps", :type=>"synonym", :status=>"synonym"}], :name_to_match=>"Formida ruficeps Smith, F., 1804"}]]]
  end

  it "should be able to add matches to merges object" do
    @fr.stubs(:merges => {})
    @fm.merge
    @fr.merges.should == {:"invasiveants:tid:1453"=>{:matches=>{:hex10354887=>{:match_type=>:fuzzy_valid_to_valid, :path=>["Formicidae", "Pachycondyla", "Pachycondyla solitaria"], :path_ids=>["hex100521", "hex1022882", "hex10354887"]}}, :nonmatches=>{}}, :"invasiveants:tid:1407"=>{:matches=>{:hex10758181=>{:match_type=>:fuzzy_valid_to_synonym, :path=>["Formicidae", "Trapeziopelta", "Trapeziopelta diadela"], :path_ids=>["hex100521", "hex1057748", "hex10758181"]}, :hex10758108=>{:match_type=>:fuzzy_synonym_to_valid, :path=>["Formicidae", "Nothosphinctus", "Nothosphinctus silaceus"], :path_ids=>["hex100521", "hex1057733", "hex10758108"]}}, :nonmatches=>{}}, :"invasiveants:tid:1397"=>{:matches=>{:hex10357934=>{:match_type=>:fuzzy_synonym_to_synonym, :path=>["Formicidae", "Formica", "Formica lavateri"], :path_ids=>["hex100521", "hex1023020", "hex10357934"]}}, :nonmatches=>{}}}
  end

end

class FamilyReunion
  class TaxamatchWrapper

    def initialize
      @tm = Taxamatch::Base.new
      @cache = FamilyReunion::Cache.new
      @tp = FamilyReunion::TaxamatchPreprocessor.new(@cache)
    end

    def match_canonicals_lists(list1, list2)
      matches = {}
      match_candidates = @tp.get_match_candidates(list1, list2)
      [:uninomials, :binomials, :trinomials].each do |bucket|
        match_candidates.each do |name1, possible_matches|
          possible_matches.each do |name2|
            if self.send("#{bucket}_match?", name1, name2)
              matches.has_key?(name1) ? matches[name1] << name2 : matches[name1] = [name2]
            end
          end
        end
      end
      require 'ruby-debug'; debugger
      matches 
    end



  end
end

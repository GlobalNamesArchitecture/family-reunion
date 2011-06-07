class FamilyReunion
  module MatcherHelper
    private
    def format_secondary_id_matches(secondary_ids, match_type)
      secondary_ids.inject({}) do |res, i|
        i = i.to_s
        res[i] = {:match_type => match_type} unless res.has_key?(i)
        res
      end
    end

    def add_record_to_merges(primary_id, secondary_id_matches)
      if @fr.merges.has_key?(primary_id)
        secondary_id_matches.each do |key, val|
          @fr.merges[primary_id][:matches][key] = val unless @fr.merges[primary_id][:matches].has_key?(key)
        end
      else
        @fr.merges[primary_id] = {:matches => secondary_id_matches, :nonmatches => []}
      end
    end
  end
end

class FamilyReunion
  class Node
    attr :data

    def initialize(data)
      @data = data
      @valid_names_hash = nil
      @valid_names_duplicates = nil
      @synonyms_hash = nil
    end

    def valid_names_hash
      return @valid_names_hash if @valid_names_hash #TODO: make it more robust for situations with exceptions etc.
      @valid_names_duplicates = {}
      @valid_names_hash = {}
      @data[:leaves].each do |row|
        canonical = row[:valid_name][:canonical_name]
        if @valid_names_hash.has_key?(canonical)
          if @valid_names_duplicates.has_key?(canonical)
            @valid_names_duplicates[canonical] << row
          else
            @valid_names_duplicates[canonical] = [row]
          end
        else
          @valid_names_hash[canonical] = row
        end
      end
      @valid_names_duplicates.keys.each do |k| 
        @valid_names_duplicates[k] << @valid_names_hash.delete(k)
      end
      @valid_names_hash
    end

    def synonyms_hash
      return @synonyms_hash if @synonyms_hash
      @synonyms_hash = {}
      @valid_names_hash.keys.each do |name|
        synonyms = @valid_names_hash[name][:synonyms]
        synonyms.each do |syn|
          @synonyms_hash.has_key?(syn[:canonical_name]) ? @synonyms_hash[syn[:canonical_name]] << @valid_names_hash[name] : @synonyms_hash[syn[:canonical_name]] = [@valid_names_hash[name]]
        end
      end
      @synonyms_hash
    end

    def valid_names_duplicates
      valid_names_hash unless @valid_names_duplicates
      @valid_names_duplicates
    end

  end
end

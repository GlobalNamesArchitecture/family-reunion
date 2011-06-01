class FamilyReunion
  class FuzzyMatcher
    def initialize(family_reunion, secondary_nonmatched_ids = [])
      @fr = family_reunion
      @tm = Taxamatch::Base.new
      @primary_names, @secondary_names = all_names_sets 
      @word_letters = {}
      @potential_matches = {}
    end

    def merge
      valid_matches = get_valid_matches
      add_valid_matches(valid_matches)
    end

    private

    def all_names_sets
      primary_names = @fr.primary_valid_names_set | @fr.primary_synonyms_set
      secondary_names = @fr.secondary_valid_names_set | @fr.secondary_synonyms_set
      [primary_names, secondary_names]
    end

    def get_valid_matches
      primary_names = @fr.primary_valid_names_set - @fr.secondary_valid_names_set
      secondary_names = @fr.secondary_valid_names_set - @fr.primary_valid_names_set
      valid_matches = match_names_lists(primary_names, secondary_names)
      require 'ruby-debug'; debugger
      puts ''
    end

    def match_names_lists(primary_names, secondary_names)
      matches = {}
      primary_names.each do |name1|
        secondary_names.each do |name2|
          if @tm.taxamatch(name1, name2)
            matches.has_key?(name1) ? matches[name1] << name2 : matches[name1] = [name2]
          end
        end
      end
      matches
    end

    # def get_valid_matches(primary_names, secondary_names)
    #   res = {}
    #   primary_names.each do |primary_name|
    #     secondary_names.each do |secondary_name|
    #       if @tm.taxamatch(primary_name, secondary_name)
    #         res.has_key?(primary_name) ? res[primary_name] << secondary_name : res[primary_name] = [secondary_name]
    #       end
    #     end
    #   end
    #   res
    # end

    
  end
end

__END__
    def preprocess_names
      @primary_names = @primary_names - @secondary_names
      @secondary_names = @secondary_names - @primary_names
      @primary_names.each do |name|
        find_potential_matches(name)  
      end
    end
    

    def match_valid_names(name)
    end

    def match_synonym_names(name)
    end
    
    
    def self.are_similar_words(word1, word2)
      word1 = @word_letters[word1]
      word2 = @word_letters[word2]
      average_uniq_length = (word1.uniq.size + word2.uniq.size)/2.0
      similar_letters = (word1 & word2).size/average_uniq_length <= 0.2
      similar_length = (word1.size - word2.size).abs.to_f/((word1.size + word2.size)/2.0)
      similar_letters && similar_length
    end


    private



    def find_potential_matches(name1)
      @potential_matches[name1] = []
      @secondary_names.each do |name2|
        @potential_matches[name1] << name2 if is_potential_match?(name1, name2)
      end
      require 'ruby-debug'; debugger
      puts ''
    end

    def is_potential_match?(name1, name2)
      genus1, species1, infraspecies1 = name1.split(/\s+/)
      genus2, species2, infraspecies2 = name2.split(/\s+/)
      return false if [infraspecies1, infraspecies2].compact.size == 1 
      [genus1, genus2, species1, species2, infraspecies1, infraspecies2].each do |word|
        next unless word
        @word_letters[word] = word.split('') unless @word_letters.has_key?(word) 
      end
      is_similar_size = ((name1.size - name2.size).abs.to_f/name1.size) <= 0.2
      return false unless is_similar_size
      is_similar_genus = FuzzyMatcher.are_similar_words(genus1, genus2)
      
      is_similar_species = FuzzyMatcher.are_similar_words(species1, species2)
      return true if is_similar_genus && is_similar_species && !(infraspecies1 && infraspecies2) 
      is_similar_infraspecies = (infraspecies1 && infraspecies2) ? FuzzyMatcher.are_similar_words(infraspecies1, infraspecies2) : nil
      res = is_similar_genus && is_similar_species 
      res = res && is_similar_infraspecies unless is_similar_infraspecies == nil
      res
    end


  end
end

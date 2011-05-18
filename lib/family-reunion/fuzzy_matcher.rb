class FamilyReunion
  class FuzzyMatcher
    def initialize(family_reunion)
      @family_reunion = family_reunion
      @primary_names, @secondary_names = @family_reunion.all_names_sets 
      @word_letters = {}
      @potential_matchers = {}
      preprocess_names
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

    def preprocess_names
      @primary_names = @primary_names - @secondary_names
      @secondary_names = @secondary_names - @primary_names
      @primary_names.each do |name|
        find_potential_matches(name)  
      end
    end

    def find_potential_matches(name1)
      @potential_matchers[name1] = []
      @secondary_names.each do |name2|
        @potential_matchers[name1] << name2 if is_potential_match?(name1, name2)
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

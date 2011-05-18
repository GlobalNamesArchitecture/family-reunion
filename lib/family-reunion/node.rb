require 'profiler'

class FamilyReunion
  class Node
    attr :data

    def initialize(data)
      @data = data
      @current_names_hash = {}
      @current_names_dupl = nil
    end

    def current_names_hash
      Profiler__::start_profile
      @current_names_dupl = {}
      @data[:leaves].each do |row|
        canonical = row[:current_name][:canonical_name]
        row.merge!({:id => row[:path_ids].last})
        if @current_names_hash.has_key?(canonical)
          if @current_names_dupl.has_key?(canonical)
            @current_names_dupl[canonical] << row
          else
            @current_names_dupl[canonical] = [row]
          end
        else
          @current_names_hash[canonical] = row
        end
      end
      @current_names_dupl.keys.each do |k| 
        @current_names_dupl[k] << @current_names_hash.delete(k)
      end
      Profiler__::stop_profile
      Profiler__::print_profile($stderr)
      @current_names_hash
    end

    def current_names_dupl
      current_names_hash unless @current_names_dupl
      @current_names_dupl
    end

  end
end

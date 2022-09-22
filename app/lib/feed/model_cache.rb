module Feed
  class ModelCache
    def initialize
      @cache = Hash.new { |hash, key| hash[key] = [] }
    end

    def add(type, *models)
      key = type_to_sym(type)
      (@cache[key] += models.flatten).uniq!
    end

    def cache(type = nil)
      type.nil? ? @cache : @cache[type_to_sym(type)]
    end

    def select_by_attribute_values(type, **attributes)
      cache_to_search = cache(type_to_sym(type))
      cache_to_search.select do |model_instance|
        model_instance.slice(attributes.keys).values == attributes.values
      end
    end

    def select_attribute_values(attribute, type = nil)
      if type.nil?
        cache.reduce([]) do |found_values, type_cache|
          models = type_cache[1]
          found_values += models.pluck(attribute) if models.first.respond_to?(attribute)
          found_values
        end.uniq!
      else
        cache_to_search = cache(type)
        cache_to_search.pluck(attribute) if cache_to_search[0].respond_to?(attribute)
      end
    end

    def debug_print
      puts "Contains #{cache.count} typed caches"

      cache.each do |class_cache|
        puts " #{class_cache[0]} - #{class_cache[1].count} items"
      end
    end

    private

    def type_to_sym(type)
      type.name.downcase.to_sym
    end
  end
end

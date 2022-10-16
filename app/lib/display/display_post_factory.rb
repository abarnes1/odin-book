module Display
  class DisplayPostFactory
    def self.create_for(post, cache = nil)
      display_post = DisplayPost.new(post)
      return display_post if cache.nil? || cache.empty?

      yield display_post if block_given?

      display_post
    end

    def self.just_extend(post, cache = nil)
      
    end
  end
end
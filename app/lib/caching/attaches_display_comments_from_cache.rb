module Caching
  class AttachesDisplayCommentsFromCache
    def self.attach(model, cache)
      return if cache.nil?

      comments = cache.retrieve_comments(model)
      return if comments.empty?

      model.display_comments = comments.map { |comment| Display::DisplayComment.new(comment) }
      model.display_comments.each { |comment| attach(comment, cache) }
    end
  end
end

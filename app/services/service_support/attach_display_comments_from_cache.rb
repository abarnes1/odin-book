# frozen_string_literal: true

module ServiceSupport
  # Start with a model that has displayable comments and
  # recursively attach child displayed comments until no
  # additional comments in the chain are found within the cache.
  module AttachDisplayCommentsFromCache
    def self.attach(model, cache)
      return model if cache.nil?

      comments = cache.retrieve_comments_for(model_class(model))
      return model if comments.empty?

      model.display_comments = comments.map { |comment| CommentPresenter.new(comment) }
      model.display_comments.each { |comment| attach(comment, cache) }

      model
    end

    class << self
      def model_class(model)
        return model if [Post, Comment].include? model.class

        model.__getobj__
      end
    end
  end
end

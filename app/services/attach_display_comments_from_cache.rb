# frozen_string_literal: true

# Start with a model that has displayable comments and
# recursively attach child displayed comments until no
# additional comments in the chain are found within the cache.
class AttachDisplayCommentsFromCache
  def self.attach(model, cache)
    return model if cache.nil?

    comments = cache.retrieve_comments(model)
    return model if comments.empty?

    model.display_comments = comments.map { |comment| comment.extend DisplayableComments }
    model.display_comments.each { |comment| attach(comment, cache) }

    model
  end
end

# frozen_string_literal: true

# Custom caching object used to temporarily store and retrieve comments
# so they can be assigned to presenter objects without additional trips
# to the database.
class CommentsCache
  def initialize
    @cached_comments = nil
  end

  def empty?
    cached_comments.empty?
  end

  def store_comments(models)
    keyed_groups = models.group_by do |model|
      storage_key(model)
    end

    cached_comments.merge!(keyed_groups)
  end

  def retrieve_comments_for(model)
    comments = cached_comments[retrieval_key(model)]
    return [] if comments.empty?

    comments
  end

  private

  def storage_key(model)
    if model.top_level?
      "post_#{model.post_id}_comments".to_sym
    else
      "comment_#{model.parent_comment_id}_replies".to_sym
    end
  end

  def retrieval_key(model)
    if model.is_a? Post
      "post_#{model.id}_comments".to_sym
    else
      "comment_#{model.id}_replies".to_sym
    end
  end

  def cached_comments
    @cached_comments ||= Hash.new { |hash, key| hash[key] = {} }
  end
end

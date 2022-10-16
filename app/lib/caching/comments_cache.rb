# frozen_string_literal: true

module Caching
  # Custom caching object used to temporarily store and retrieve comments
  # so they can be assigned to presenter objects without additional trips
  # to the database.
  class CommentsCache
    attr_reader :root_nodes

    def initialize
      @cached_comments = nil
    end

    def empty?
      cached_comments.empty?
    end

    def store(models)
      keyed_groups = models.group_by do |model|
        storage_key(model)
      end

      cached_comments.merge!(keyed_groups)
    end

    def storage_key(model)
      if [Post, Display::DisplayPost].include? model.class
        "post_#{model.id}_comments".to_sym
      elsif model.parent_comment_id?
        "comment_#{model.parent_comment_id}_replies".to_sym
      else
        "post_#{model.post_id}_comments".to_sym
      end
    end

    def retrieval_key(model)
      if [Post, Display::DisplayPost].include? model.class
        "post_#{model.id}_comments".to_sym
      else
        "comment_#{model.id}_replies".to_sym
      end
    end

    def retrieve_comments(model)
      cached_comments[retrieval_key(model)]
    end

    def cached_comments
      @cached_comments ||= Hash.new { |hash, key| hash[key] = {} }
    end
  end
end

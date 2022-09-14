class CommentsCache
  def self.for(*args)
    models = args.flatten

    if models.empty?
      CommentsCache.new([])
    elsif models.all?(Post)
      PostsCommentsCache.new(models)
    elsif models.all?(Comment)
      CommentsRepliesCache.new(models)
    else
      raise ArgumentError, 'unsupported model type'
    end
  end

  def initialize(models)
    @ids_to_query = models.map(&:id)
  end

  def comments_for(model)
    comments_cache[model.id] || []
  end

  def reply_cache
    @reply_cache ||= CommentsCache.for(comments)
  end

  def replies
    reply_cache.comments
  end

  def comments
    @comments ||= comments_cache.values.flatten
  end

  private

  def ids_to_query
    @ids_to_query ||= []
  end

  def comments_cache
    @comments_cache ||= fetch_comments
  end

  def fetch_comments
    {}
  end
end

module Feed
  class FeedComment
    attr_reader :created_at, :id, :message, :replies

    def initialize(comment, user)
      @id = comment.id
      @replies = []
      @created_at = comment.created_at
      @user = user
      @message = comment.message
    end

    def author
      user.username
    end

    def add_reply(reply)
      replies << reply
    end

    private 

    attr_writer :replies
    attr_reader :user
  end
end
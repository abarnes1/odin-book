module DisplayComments
  extend ActiveSupport::Concern

  included do
    attr_writer :display_comments

    def first_displayed
      display_comments.first
    end

    def display_comments?
      displayed_comments_count.positive?
    end

    def remaining_comments?
      remaining_comments.positive?
    end

    def remaining_comments_count
      comments_count - display_comments.size
    end

    def displayed_comments_count
      display_comments.size
    end

    def display_comments
      @display_comments || []
    end
  end
end
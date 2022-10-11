module DisplayComments
  extend ActiveSupport::Concern

  included do
    attr_writer :display_comments

    def first_displayed
      display_comments.first
    end

    def last_displayed
      display_comments.last
    end

    def last_displayed_id
      return nil unless display_comments?

      last_displayed.id
    end

    def display_comments?
      displayed_comments_count.positive?
    end

    def remaining_comments?
      remaining_comments_count.positive?
    end

    def remaining_comments_count
      count = comments_count.nil? ? 0 : comments_count
      count - display_comments.size
    end

    def displayed_comments_count
      display_comments.size
    end

    def display_comments
      @display_comments || []
    end
  end
end
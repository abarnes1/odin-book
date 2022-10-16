module Display
  class DisplayComment < SimpleDelegator
    def initialize(delegate, display_comments = nil)
      super(delegate)
      @display_comments = display_comments.nil? ? nil : [display_comments].flatten
    end

    def display_comments
      @display_comments ||= []
    end
    
    def display_comments=(comments)
      @display_comments = comments
    end

    def display_comments?
      !display_comments.empty?
    end

    def displayed_comments_count
      display_comments.size
    end

    def not_displayed_comments?
      not_displayed_comments_count.positive?
    end

    def not_displayed_comments_count
      count = comments_count.nil? ? 0 : comments_count
      count - displayed_comments_count
    end

    def all_comments_displayed?
      not_displayed_comments_count.zero?
    end

    def oldest_display_comment
      return nil if display_comments.empty?

      display_comments.min { |a, b| a.created_at <=> b.created_at }
    end
  end
end
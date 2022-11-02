# frozen_string_literal: true

# Enables behaviors to both have display comments and provide counters
# for which comments are and are not displayed.  Classes that extend
# this module must be able to provide a #comments_count to calculate
# displayed and not_displayed counts.
module DisplayableComments
  def display_comments
    @display_comments ||= []
  end

  def display_comments=(comments)
    @display_comments = [comments].flatten
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

  private

  # Array#flatten calls private method #to_ary and will issue a warning
  # that the delegator does not forward the private message.  Override
  # here as a workaround to suppress warning.
  def to_ary
    nil
  end
end

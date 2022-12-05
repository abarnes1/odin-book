# frozen_string_literal: true

# Enables behaviors to both have display comments and provide counters
# for which comments are and are not displayed.

# Classes that extend this module must be able to either:
#   1. Provide a #comments_count to calculate displayed and not_displayed counts.
#   2. Include this module with a custom comments_count method
#      ex: class Something
#            include DisplayableComments.with_custom_comments_count(:my_method)
#            def my_method; 777 end
#           end
#
#           Something.new.comments_count => 777
#
# Counts for displayed comments and not displayed comments are calculated with
# #comments_count as a starting value, but these starting values can be overridden by
# setting the instance variables @displayed_count_override and/or @not_displayed_count_override
# in classes that include this module.
#
# Similarly, #oldest_display_comment_id will be calculated based on the current #display_comments
# unless overridden by setting @oldest_display_comment_id in including classes.
module DisplayableComments
  def self.with_custom_comments_count(comments_count)
    Module.new do
      include DisplayableComments

      define_method comments_count do
        public_send(method)
      end
    end
  end

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
    if displayed_count_override
      displayed_count_override + display_comments.size
    else
      display_comments.size
    end
  end

  def not_displayed_comments?
    not_displayed_comments_count.positive?
  end

  def not_displayed_comments_count
    count =
      if not_displayed_count_override
        not_displayed_count_override - display_comments.size
      else
        counter_from_method = comments_count.nil? ? 0 : comments_count
        counter_from_method - displayed_comments_count
      end

    count.positive? ? count : 0
  end

  def all_comments_displayed?
    not_displayed_comments_count.zero?
  end

  def oldest_display_comment_id
    return oldest_display_comment_id_override if oldest_display_comment_id_override
    return nil if display_comments.empty?

    display_comments.min { |a, b| a.created_at <=> b.created_at }.id
  end

  def displayed_count_override
    @displayed_count_override
  end

  def not_displayed_count_override
    @not_displayed_count_override
  end

  def oldest_display_comment_id_override
    @oldest_display_comment_id_override
  end

  private

  # Array#flatten calls private method #to_ary and will issue a warning
  # that the delegator does not forward the private message.  Override
  # here as a workaround to suppress warning.
  def to_ary
    nil
  end
end

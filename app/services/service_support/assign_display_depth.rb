# frozen_string_literal: true

module ServiceSupport
  # Recursively assigns a progressive display depth to
  # displayable comments until no more displayable comments are found.
  module AssignDisplayDepth
    def self.assign_depth(comments, depth = 0)
      comments.each do |comment|
        comment.display_depth = depth
        assign_depth(comment.display_comments, depth + 1)
      end

      comments
    end
  end
end

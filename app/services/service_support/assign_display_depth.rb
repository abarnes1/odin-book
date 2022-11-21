module ServiceSupport
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
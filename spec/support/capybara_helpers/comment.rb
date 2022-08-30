module CapybaraHelpers
  module Comment
    def post_comment(message = 'This is a comment.')
      fill_in_comment_field(message)
      click_on 'Create Comment'
    end

    def update_comment(message = 'This is an edited comment.')
      fill_in_comment_field(message)
      click_on 'Update Comment'
    end

    private

    def fill_in_comment_field(message)
      fill_in 'Comment:', with: message
    end
  end
end
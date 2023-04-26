module CapybaraHelpers
  module Comment
    def post_comment(message = 'This is a comment.')
      fill_in_comment_field(message)
      click_on 'Comment'
    end

    def update_comment(message = 'This is an edited comment.')
      fill_in_comment_field(message)
      click_on 'Update'
    end

    private

    def fill_in_comment_field(message)
      fill_in 'comment_message', with: message
    end
  end
end
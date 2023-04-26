module CapybaraHelpers
  module Post
    def create_post(content = 'This is post content.')
      fill_in_post_content(content)
      click_on 'Create Post'
    end

    def update_post(content = 'This is an edited comment.')
      fill_in_post_content(content)
      click_on 'Update Post'
    end

    private

    def fill_in_post_content(content)
      fill_in 'post_content', with: content
    end
  end
end
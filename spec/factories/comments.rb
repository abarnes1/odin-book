FactoryBot.define do
  factory :comment do
    message { 'Default comment' }
    association :user, factory: :user

    # If parent_comment not passed in, create a post to attach the
    # comment to.  Otherwise, the parent_comment's post must exist and this
    # comment's post should be the same as the parent_comment's post.
    post { if parent_comment.nil?
            association :post, user: user 
           else
            association :post, id: parent_comment.post_id, user: user
           end }
  end
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


# create 15 users, 5 actual and 10 as filler for pagination
demo_user = User.create(email: 'demo@testuser.com', password: 'demo123', username: 'demo user', first_name: 'Demo', last_name: 'User')

15.times do |index|
  counter = index + 1
  User.create(email: "testuser#{counter}@testuser.com", password: 'test123', username: "test user #{counter}", first_name: 'Test', last_name: 'User')  
end

# Demo user gets 2 friends, 1 sent friend request, 1 received friend request, and 1 friend request notification
friend1 = User.second
friend2 = User.third

demo_user.sent_friend_requests.create(recipient: friend1, status: :accepted)
demo_user.sent_friend_requests.create(recipient: friend2, status: :accepted)
demo_user.sent_friend_requests.create(recipient: User.fourth, status: :pending)
pending_friend_request = demo_user.received_friend_requests.create(sender: User.fifth, status: :pending)
demo_user.notifications.create(notifiable: pending_friend_request, created_at: 2.hours.ago)

# Welcome post
first_post_content = <<-FIRST_FEED_POST 
  Hey! Welcome to a social media site. Scroll through the next few posts to see a few key features in action, assuming nobody has wrecked the demo user's posts and comments.
  
  Feel free to look around.
  FIRST_FEED_POST
friend1.posts.create(content: first_post_content)

# Post describing likes
likes_info = <<-LIKES_INFO
  This is just a test post.  It's visible because I'm friends with the demo user.  What!? You *are* Demo User?  Like my post and let me know you enjoy being friends.
LIKES_INFO
liked_post = friend1.posts.create(content: likes_info, created_at: 1.hour.ago)
liked_comment = liked_post.comments.create(user: friend1, post: liked_post, message: "You can like this comment too.  Someone else already has!")
liked_comment.likes.create(user: friend2)

# Post describing comment threads
comment_thread_info = <<-COMMENT_THREAD_INFO
  Look at these complicated to write with limited payoff comment threads.  This site's author earned a lot of new brain wrinkles figuring this out.  He also tackled this first thinking it should be soooo easy.  What an idiot!

  This site will initially load up to three tiers of comments at a time, with each tier holding up to three comments per post or comment each, without triggering n+1 queries.  The limits are purposefully low for demo purposes.
COMMENT_THREAD_INFO

comment_thread_post = friend2.posts.create(content: comment_thread_info, created_at: 2.hours.ago)
older_comment = comment_thread_post.comments.create(user: friend2, post: comment_thread_post, message: "This comment wasn't loaded by default.")
older_comment_reply1 = older_comment.comments.create(user: friend2, post: comment_thread_post, message: "These comments also weren't loaded by default.")
older_comment_reply1_reply1 = older_comment_reply1.comments.create(user: friend2, post: comment_thread_post, message: "This comment wasn't loaded by default.")
older_comment_reply2 = older_comment.comments.create(user: friend2, post: comment_thread_post, message: "These comments also weren't loaded by default.")
older_comment_reply2_reply1 = older_comment_reply2.comments.create(user: friend2, post: comment_thread_post, message: "This comment wasn't loaded by default.")

comment_thread_post.comments.create(user: friend2, post: comment_thread_post, message: "This is the third most recent comment.  There's an older comment you can see by clicking \"View Previous\" above this text.")
comment_thread_post.comments.create(user: friend2, post: comment_thread_post, message: "This is the second most recent comment.")
most_recent_comment = comment_thread_post.comments.create(user: friend2, post: comment_thread_post, message: "This is the most recent comment. Comments can go to any depth, but it's limited to displaying three tiers so the screen doesn't get all squished up.")
tier2_comment = most_recent_comment.comments.create(user: friend2, post: comment_thread_post, message: "This is a comment on tier 2.")
tier3_comment = tier2_comment.comments.create(user: friend2, post: comment_thread_post, message: "This is a comment on tier 3.  You can keep going lower by clicking \"Continue Conversation\" link below.")
tier4_comment = tier3_comment.comments.create(user: friend2, post: comment_thread_post, message: "This is a comment on tier 4.  Comments can go infinitely deep, but I'll only allow three tiers to be visible at a time. Want to go up a level?  Look above this comment thread for a link to the parent comment.\nIf you're just looking around, a couple presses of your browser's back button will take you back to your feed.")

# Post describing soft deletion
soft_deleted_post_content = <<-SOFT_DELETED_POST
  Psst...  Hey! Look at the post under this one.  It's been soft deleted unless someone has changed it by now. 
  
  That means that the post's content has been hidden, but continues to exist so the comments stay intact.  You can restore this post with its original message since you're the author.
  
  The same behavior works with comments.  Holy moly!
SOFT_DELETED_POST
soft_deleted_post = demo_user.posts.create(content: soft_deleted_post_content, created_at: 3.hours.ago)

example_soft_deleted_post = demo_user.posts.create(content: "Soft delete me!", soft_deleted: :true, created_at: 4.hours.ago)
example_soft_deleted_post.comments.create(user: demo_user, post: example_soft_deleted_post, message: "You can soft delete this comment too.", created_at: 4.hours.ago)

# Notifications
notification_post = friend1.posts.create(content: "You'll receive a notification when someone sends a friend request or comments on one of your posts or comments.  Look at the bell icon at the top of the page to see if there are any pending notifications.", created_at: 5.hours.ago)
notification_comment = notification_post.comments.create(user: demo_user, post: notification_post, message: "Someone comment here so I can be notified.")
notification_trigger = notification_comment.comments.create(user: friend1, post: notification_post, message: "Done. Check the notification icon.")
demo_user.notifications.create(notifiable: notification_trigger)

# Pagination post
friend1.posts.create(content: "I created my own pagination.  Next time I'll use a gem instead.", created_at: 6.hours.ago)

# Filler posts to trigger pagination
100.times do |index|
  friend1.posts.create(content: "This is a filler post so pagination works.", created_at: (index + 1).days.ago)
end



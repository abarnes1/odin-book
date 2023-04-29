# Odin Book

This the [final project](https://www.theodinproject.com/lessons/ruby-on-rails-rails-final-project) in The Odin Project's Rails curriculum.

# Live Site
You can view a live version of this site [here](https://abar.dev/odin-book/).  There's a demo login available if you don't want to sign up:

User: demo@testuser.com  
Password: demo123

You can also sign up with any email address and not worry about having to verify the address prior to logging in.

# Features
 - Users can create posts.
 - Posts can have comments.
 - Comments can have replies.
    - Replies can have replies.
    - Reply replies can have replies.
    - Seriously, it keeps going with no limits.
 - Users can send and receive friend requests.
 - Posts and comments can have "Likes".
 - Users have an activity feed that displays both their posts and those of their friends.
 - Notifications are sent for received friend requests and when another user comments on your post or comment.

# Reflections
## Learning
This was one big learning opportunity that ended up in a lot of experimentation. I gained some awareness of several concepts that exist outside of normal CRUD operations:

  - integration testing with RSpec and Capybara
  - service objects
  - presenter objects
  - breaking up controllers into smaller pieces
  - Turbo streams and frames to prevent full page loads

## The Cool Stuff
  - Being able to [load multiple tiers/depths](./app/services/load_posts_tiered_comments.rb) of comments across any number of posts without triggering n+1 queries.
  - A [pagination](./app/models/concerns/pageable.rb) concern that works well enough that it can probably be reused in the future, although an existing gem may be a wiser choice.
  - The [soft deletable](./app/models/concerns/soft_deletable.rb) concern also turned out well.  This concern exists so deleting a post or comment will not delete child comments that belong to other users.  If I need to attach this behavior to models in the future, it is nearly usable as-is in my opinion.  
  - Nested comments.  It turned out to be more challenging than it sounded and I'm happy I was able to find a solution that allows

## The Not-so-Cool Stuff
The original plan for this project was lacking.  Not having a better plan upfront made it too easy to rethink decisions and get stuck in refactoring without a clear end goal.

Naming things is also hard.  I definitely struggled on how to best break up and name views in a way that made enough sense that I could easily step back into this project and figure out what was going on.  It's something to be more conscious about going forward.

## Improvements
If I had to do this all again I would focus a little more on service objects.  I think they are a good place to keep more complex logic that isn't directly related to CRUD operations on model classes.  The general wisdom is to have a fat model and skinny controller, but cramming most logic into the model feels like too much to me.

It would be nice for comments to appear in real time, but would probably take some heavy refactoring on how comments and some counts relating to which comments are displayed.

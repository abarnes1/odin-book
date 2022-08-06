# Project Overview
## Requirements
### Required
1. Users must sign in to see anything except the sign in page.
    - Basics set up 8/2/2022.  Will need to ensure as controllers are added that
      they enforce authentication via `before_action :authenticate_user!`
1. Users can send friend requests to other users.
1. A user must accept the friend request to become friends.
1. The friend request shows up in the notifications section of a user's navbar.
1. Users can create posts.
1. Users can like posts.
1. Users can comment on posts.
1. Posts should always display the post content, author, comments, and likes.
1. The posts index page shows a "timeline" of all recent posts from the current user and users they are friends with.
1. Users can create a profile with their personal information and a photo. (Gravatar)
    - All but photo 8/5/2022.
    - Gravatar working 8/6/2022.
1. The user show page contains their profile information, photo, and posts.
1. The users index page lists all users and buttons for sending friend requests to those who are not already friends or who don't already have a pending request.
1. Sign in using OmniAuth to allow users to sign in with their real Facebook account.
1. Users receive a welcome email when signing up.

### Optional
1. Posts allow images, whether by url or by uploading one.
1. A user can upload a profile photo using Active Storage.
1. Posts can be either text or a photo by using a polymorphic association.

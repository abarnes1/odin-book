module FriendshipRequestHelper
  def friendship_button_text(user, friend)
    if user.friends.include?(friend)
      'Remove Friendship'
    elsif user.requested_friendship_with?(friend)
      'Cancel Request'
    elsif user.friendship_requested_by?(friend)
      'Accept Request'
    else
      'Request Friendship'
    end
  end
end

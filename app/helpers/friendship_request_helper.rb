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

  def friendship_button_class(user, friend)
    if user.friends.include?(friend)
      'is-danger'
    elsif user.requested_friendship_with?(friend)
      'is-danger'
    elsif user.friendship_requested_by?(friend)
      'is-primary'
    else
      'is-link'
    end
  end

  def friendship_form_method(user, friend)
    if user.friends?(friend) || user.requested_friendship_with?(friend)
      :delete
    elsif user.friendship_requested_by?(friend)
      :patch
    else
      :post
    end
  end

  def friendship_confirm_message(user, friend)
    if user.friends?(friend)
      'Really remove friendship?'
    elsif user.requested_friendship_with?(friend)
      'Really cancel friendship request?'
    end
  end
end

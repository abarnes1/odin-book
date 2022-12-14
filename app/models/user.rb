class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :username, :first_name, :last_name, presence: true

  has_many :posts, inverse_of: :user
  has_many :likes, inverse_of: :user
  has_many :comments, inverse_of: :user

  # uniqueness at model level
  # https://nelsonfigueroa.dev/uniqueness-constraint-between-two-columns-in-rails/

  has_many :sent_friend_requests, -> { FriendshipRequest.pending },
           class_name: 'FriendshipRequest', foreign_key: :sender_id
  has_many :received_friend_requests, -> { FriendshipRequest.pending },
           class_name: 'FriendshipRequest', foreign_key: :recipient_id

  def friends
    @friends ||= friends_as_active_record_custom_sql.to_a
  end

  def friends?(user)
    friends.include?(user)
  end

  def requested_friendship_with?(user)
    friend_request_user_ids.include?(user.id)
  end

  def friendship_requested_by?(user)
    requested_friend_user_ids.include?(user.id)
  end

  private

  def friends_as_active_record_custom_sql
    join_clause = <<~SQL
      JOIN friendship_requests
        ON users.id =
          CASE
            WHEN friendship_requests.sender_id = #{id}
              THEN friendship_requests.recipient_id
            ELSE
              friendship_requests.sender_id
          END
    SQL

    User.joins(join_clause).merge(FriendshipRequest.accepted)
  end

  def friend_request_user_ids
    @friend_request_user_ids ||= sent_friend_requests.pluck(:recipient_id).to_a
  end

  def requested_friend_user_ids
    @requested_friend_user_ids ||= received_friend_requests.pluck(:sender_id).to_a
  end
end

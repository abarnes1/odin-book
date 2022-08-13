class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :username, :first_name, :last_name, presence: true

  has_many :posts

  # uniqueness at model level
  # https://nelsonfigueroa.dev/uniqueness-constraint-between-two-columns-in-rails/

  has_many :sent_friend_requests, -> { FriendshipRequest.pending },
           class_name: 'FriendshipRequest', foreign_key: :sender_id
  has_many :received_friend_requests, -> { FriendshipRequest.pending },
           class_name: 'FriendshipRequest', foreign_key: :recipient_id

  def friends
    query = <<~SQL
      SELECT users.*
      FROM friendship_requests
        JOIN users
          ON users.id =
            CASE
              WHEN friendship_requests.sender_id = #{id}
                THEN friendship_requests.recipient_id
              ELSE
                friendship_requests.sender_id
            END
      WHERE friendship_requests.status = 'accepted'
    SQL

    User.find_by_sql(query)
  end
end

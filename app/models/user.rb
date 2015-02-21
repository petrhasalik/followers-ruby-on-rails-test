class User < ActiveRecord::Base

  has_many :followings_associaton, class_name: 'Following'
  has_many :followings, through: :followings_associaton, source: :following

  validates :name, uniqueness: true, presence: true

  # Finds user in database and creates relation between that user and current user
  # if there isn't any relation yet
  # Throws ActiveRecord::RecordNotFound if user with given ID is not found
  def follow(id)
    if id == self.id
      false
    else
      following = User.find(id)
      following_relation = Following.find_by(user: self, following: following)
      Following.create(user: self, following: following) if following_relation.nil?
      true
    end
  end

  # Does current user follow given user?
  def follows?(id)
    user = User.find(id)
    self.followings.include?(user)
  end

  # Finds user in current list of followings and removes relation between them
  def unfollow(id)
    if id == self.id
      false
    else
      following = self.followings.find(id) # checks if there's relation between users
      following_relation = Following.find_by(user: self, following: following)
      following_relation.destroy unless following_relation.nil?
      self.reload # we have to do this to refresh objects in relation
      true
    end
  end

  # Returns list of users which follow current user
  def followers
    # 'includes' saves us ton of SELECTs
    Following.includes(:user).where(following: self).collect { |f| f.user }
  end

  # Returns list of users which are not yet followed by current user
  def nonfollowings
    User.all - [self] - followings
  end

end
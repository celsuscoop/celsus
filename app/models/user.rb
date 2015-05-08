class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :contents
  has_many :warnings
  has_many :user_activities
  has_many :posts

  ROLE = %w{ guest contributor admin su}
  ROLE_EDIT = %w{ guest contributor admin}

  def admin?
    role == 'admin' || email == 'celsuscoop@gmail.com' || role == 'su'
  end

  def su?
    role == 'su'
  end

  def contributor?
    role == 'contributor'
  end
end

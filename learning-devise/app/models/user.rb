class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :confirmable

  attr_accessor :login

  has_many :posts
  has_many :collaborations

  validates :username, uniqueness: { case_sensitive: false }

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = ( conditions.delete(:login) || conditions.delete(:email))
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", 
        { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end
end

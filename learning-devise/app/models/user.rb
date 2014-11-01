class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :confirmable, :omniauthable

  attr_accessor :login

  has_many :posts
  has_many :collaborations

  validates :username, uniqueness: { case_sensitive: false }

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    logger.info "\n--------CONDITIONS: #{conditions.inspect}\n"
    if login = ( conditions.delete(:login) || conditions.delete(:email))
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", 
        { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.process_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.nickname
      user.email = auth.info.email
    end
  end
end

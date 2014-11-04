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
    # logger.debug "\n--------CONDITIONS: #{conditions.inspect}\n"
    if login = ( conditions.delete(:login) || conditions.delete(:email))
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", 
        { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.process_omniauth(auth)
    where(auth.to_hash.slice("provider", "uid")).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.nickname
      user.email = auth.info.email
      user.confirmed_at = Time.now
    end
  end

  def self.new_with_session(params,session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def update_with_password(params, *options)
    if encrypted_password.blank? && provider.present?
      update_attributes(params, *options)
    else
      super
    end
  end

  # no password needed for auth via provider
  def password_required?
    super && provider.blank?
  end

  def user_params
    params.require(:user).permit(:email,:username,:password,:address,:provider,:uid)
  end
end

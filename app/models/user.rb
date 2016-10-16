class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save { self.email = email.downcase }
  before_create :create_activation_digest
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false, message: 'Email taken. Already have an account? <a href="/login?location=apply">Sign in here.</a>' }
  validates :password, length: { minimum: 6 }, allow_nil: true
  has_secure_password

  has_many :grant_details
  has_many :grant_reviews, through: :grant_details

  has_one :state_declaration

  def self.admin_users
    where(admin: true)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def regen_activation_digest
    self.create_activation_digest
    self.save
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def fullname
    if grant_details.any?
      "#{grant_details.first.forename} #{grant_details.first.surname}"
    end
  end

end

# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password_digest, :password, :password_confirmation
  has_secure_password

  before_save { |user| user.email.downcase! }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.(?:[A-Z]{2}|com|org|net|edu|gov|gouv|mil|biz|info|mobi|name|aero|asia|jobs|museum)$/i

  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }


  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
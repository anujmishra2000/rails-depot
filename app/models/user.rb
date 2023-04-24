class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_secure_password

  validates :email, uniqueness: { case_sensitive: false }, email: true

  after_destroy :ensure_an_admin_remains
  after_create :ensure_send_email_to_user
  before_destroy :ensure_user_is_not_admin
  before_update :ensure_user_is_not_admin

  class Error < StandardError
  end

  private

  def ensure_send_email_to_user
    UserMailer.welcome(self).deliver_now
  end

  def ensure_user_is_not_admin
    if email == ADMIN_EMAIL
      errors.add(:base, 'Cannot update/destroy Admin')
      throw :abort
    end
  end

  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end  
end
class User < ApplicationRecord

  validates :name, presence: true, uniqueness: true
  has_secure_password
  validates :email, uniqueness: { case_sensitive: false }, email: true

  after_destroy :ensure_an_admin_remains
  after_create_commit :send_welcome_email
  before_destroy :do_not_destroy_admin, if: :is_admin?
  before_update :do_not_update_admin, if: -> { :is_admin? || was_admin? }

  class Error < StandardError
  end

  private

  def is_admin?
    email == ADMIN_EMAIL
  end

  def was_admin?
    email_was == ADMIN_EMAIL
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end

  def do_not_destroy_admin
    errors.add(:base, 'Cannot destroy Admin')
    throw :abort
  end

  def do_not_update_admin
    errors.add(:base, 'Cannot update Admin')
    throw :abort
  end

  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end
end

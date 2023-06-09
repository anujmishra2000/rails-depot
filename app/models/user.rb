class User < ApplicationRecord
  has_many :orders, dependent: :restrict_with_error
  has_many :line_items, through: :orders
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true, update_only: true

  validates :name, presence: true, uniqueness: true
  has_secure_password
  validates :email, uniqueness: { case_sensitive: false }, email: true

  after_destroy :ensure_an_admin_remains
  after_create_commit :send_welcome_email
  before_destroy :ensure_do_not_destroy_admin
  before_update :ensure_do_not_update_admin

  class Error < StandardError
  end

  def admin?
    role == 'admin'
  end

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end

  def ensure_do_not_destroy_admin
    if email == ::ADMIN_EMAIL
      errors.add(:base, 'Cannot destroy Admin')
      throw :abort
    end
  end

  def ensure_do_not_update_admin
    if email_was == ::ADMIN_EMAIL
      errors.add(:base, 'Cannot update Admin')
      throw :abort
    end
  end

  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end
end

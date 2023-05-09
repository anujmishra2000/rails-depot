class Category < ApplicationRecord
  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :parent, class_name: 'Category', optional: :true
  has_many :products, dependent: :restrict_with_error
  has_many :sub_categories_products, through: :sub_categories, source: :products, dependent: :restrict_with_error

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false, scope: :parent_id }, allow_blank: true
  validates_with OneLevelNestingValidator, if: :parent_id?

  after_update_commit :set_products_count, if: :has_parent_id_changed?

  scope :root, -> { where(parent_id: nil) }

  def update_products_count
    parent&.update_columns(products_count: (parent.products.size + parent.sub_categories_products.size))
    update_columns(products_count: (products.size + sub_categories_products.size))
  end

  private

  def set_products_count
    Category.find_by(id: parent_id_before_last_save)&.update_products_count
    Category.find_by(id: parent_id)&.update_products_count
  end

  def has_parent_id_changed?
    parent_id_before_last_save != parent_id
  end
end

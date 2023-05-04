class Category < ApplicationRecord
  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_category_id', dependent: :destroy
  belongs_to :parent_category, class_name: 'Category', optional: :true
  has_many :products, dependent: :restrict_with_error
  has_many :sub_categories_products, through: :sub_categories, source: :products, dependent: :restrict_with_error

  validates :name, presence: true
  validates :name, uniqueness: { scope: :parent_category_id }, allow_blank: true
  validate :no_child_of_subcategories

  after_update_commit :set_products_count, if: :has_parent_category_id_changed?

  private

  def set_products_count
    Category.find(parent_category_id_before_last_save).decrement!(:products_count, products_count)
    parent_category&.increment!(:products_count, products_count)
  end

  def has_parent_category_id_changed?
    parent_category_id_before_last_save != parent_category_id
  end

  def has_grandparent?
    parent_category&.parent_category_id? && parent_category_id?
  end

  def has_grandchild?
    Category.exists?(parent_category_id: sub_category_ids)
  end

  def has_parent_and_child?
    parent_category_id? && sub_categories.present?
  end

  def no_child_of_subcategories
    if has_grandparent? || has_grandchild? || has_parent_and_child?
      errors.add :base, :nesting_level_too_deep, message: 'only one level of nesting is allowed'
    end
  end
end

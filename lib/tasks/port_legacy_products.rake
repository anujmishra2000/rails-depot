desc 'Assign first category to all products without Category'
task :port_legacy_products => :environment do
  Product.where(category_id: nil).update_all(category_id: Category.first.id)
end

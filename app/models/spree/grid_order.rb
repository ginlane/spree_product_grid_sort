class Spree::GridOrder < ActiveRecord::Base
  belongs_to :product, class_name: "Spree::Product"
  belongs_to :taxonomy, class_name: "Spree::Taxonomy"
  acts_as_list scope: :taxonomy_id, add_new_at: :top

  validates_uniqueness_of :spree_product_id, scope: [ :spree_taxonomy_id ], message: :already_linked
end

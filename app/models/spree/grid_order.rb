class Spree::GridOrder < ActiveRecord::Base
  belongs_to :ordered_product, class_name: "Spree::Product", foreign_key: :product_id
  belongs_to :taxon
  acts_as_list scope: :taxon_id, add_new_at: :bottom

  def self.reorder(taxon_id, positions)
    ids, positions = positions.transpose
    products       = Spree::Product.find ids
    map            = Hash[ids.zip(positions)]
    products.each do |p|
      grid_order = p.grid_order(taxon_id) || create(ordered_product: p, taxon_id: taxon_id)
      grid_order.set_list_position map[p.id]
    end
  end
end

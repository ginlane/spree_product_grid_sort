class Spree::Classification < ActiveRecord::Base
  self.table_name = 'spree_products_taxons'
  belongs_to :product, class_name: "Spree::Product"
  belongs_to :taxon, class_name: "Spree::Taxon"

  acts_as_list scope: :taxon_grid 
  belongs_to :taxon_grid

  after_initialize -> {
    return unless new_record?
    self.taxon_grid ||= taxon.taxon_grids.last
  }

  def self.reorder(taxon_id, positions)
    ids, positions = positions.transpose
    products       = Spree::Product.find ids
    map            = Hash[ids.zip(positions)]
    products.each do |p|
      p.classifications.find_by(taxon_id:taxon_id).update(position:map[p.id])
    end
  end  
end
class Spree::Classification < ActiveRecord::Base
  self.table_name = 'spree_products_taxons'
  belongs_to :product, class_name: "Spree::Product"
  belongs_to :taxon, class_name: "Spree::Taxon"

  belongs_to :taxon_grid
  
  acts_as_list scope: :taxon_grid

  after_initialize -> {
    ensure_taxon_grid if new_record? && taxon_id.present?
  }

  def taxon=(t)
    super t
    ensure_taxon_grid
  end

  def ensure_taxon_grid
    self.taxon_grid ||= taxon.taxon_grids.last rescue binding.pry    
  end

  def self.reorder(taxon_id, positions)
    ids, positions = positions.transpose
    products       = Spree::Product.find ids
    map            = Hash[ids.zip(positions)]
    products.each do |p|
      p.classifications.find_by(taxon_id:taxon_id).update(position:map[p.id])
    end
  end  
end
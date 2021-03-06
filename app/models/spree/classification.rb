class Spree::Classification < ActiveRecord::Base
  self.table_name = 'spree_products_taxons'
  belongs_to :product, class_name: "Spree::Product"
  belongs_to :taxon, class_name: "Spree::Taxon"

  belongs_to :taxon_grid

  acts_as_list scope: :taxon_grid_id, add_new_at: :bottom

  before_save -> {
    ensure_taxon_grid if taxon_id.present? && taxon_grid_id.empty?
    ensure_taxon if taxon_grid_id.present? && taxon.empty?
  }

  def taxon=(t)
    super t
    ensure_taxon_grid
  end
  def taxon_grid=(tg)
    super tg
    ensure_taxon
  end

  def ensure_taxon_grid
    self.taxon_grid ||= taxon.grid.last
  end

  def ensure_taxon
    self.taxon ||= taxon_grid.taxon
  end


  def self.reorder(taxon_id, positions)
    ids, positions = positions.transpose
    products       = Spree::Product.find ids
    map            = Hash[ids.zip(positions)]
    products.each do |p|
      p.classifications.find_by(taxon_grid_id:taxon_id).update_column(:position, map[p.id])
    end
  end
end

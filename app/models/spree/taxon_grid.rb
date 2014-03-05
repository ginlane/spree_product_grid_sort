class Spree::TaxonGrid < ActiveRecord::Base
  belongs_to :taxon

  has_many :classifications, -> {order(:position)}
  has_many :products, -> {order("#{Spree::Classification.table_name}.position ASC")}, through: :classifications

  after_create -> {
    # only copy if there's one existing
    return unless not_me = taxon.taxon_grids.where.not(id:id)
    return unless copy_me = not_me.last

    copy_me.classifications.each do |c|
      classifications.create product_id:c.product_id, taxon_id: c.taxon_id, position: c.position, taxon_grid_id: id
    end
  }

end
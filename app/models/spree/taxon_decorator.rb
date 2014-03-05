module Spree
  Taxon.class_eval do
    has_many  :products, through: :taxon_grid, source: :products do
      def <<(p)
        proxy_association.owner.taxon_grid.products << p
      end
      def push(p)
        proxy_association.owner.taxon_grid.products << p
      end
    end

    has_many    :taxon_grids, -> {order(:available_on)}
    belongs_to  :taxon_grid
    has_many    :available_grids, -> {where(["#{Spree::TaxonGrid.table_name}.available_on < ?",Time.now])}, class_name: 'Spree::TaxonGrid'
    has_many    :grid_products, through: :taxon_grid, source: :products, class_name: 'Spree::Product'

    after_initialize -> {
      self.taxon_grids.build(available_on:1.day.ago) if new_record?
      self.taxon_grid_id ||= (available_grids.last || taxon_grids.last).try :id
    }
  end
end

module Spree
  Taxon.class_eval do
    delegate :products, to: :taxon_grid

    has_many    :taxon_grids, -> {order(:available_on)} do
      def available
        where(["#{Spree::TaxonGrid.table_name}.available_on < ?",Time.now])        
      end
    end
    alias_method :grids, :taxon_grids

    has_one     :taxon_grid, -> {where(["#{Spree::TaxonGrid.table_name}.available_on < ?",Time.now])}
    alias_method :grid, :taxon_grid

    after_initialize -> {
      taxon_grids.build(available_on:1.day.ago) if new_record?
    }
  end
end

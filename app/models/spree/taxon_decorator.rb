module Spree
  Taxon.class_eval do
    has_many    :products, through: :taxon_grid, source: :products do
      def <<(p)
        proxy_association.owner.taxon_grid.products << p
      end
      def push(p)
        proxy_association.owner.taxon_grid.products << p
      end
    end

    has_many    :taxon_grids, -> {order(:available_on)} do
      def available
        where(["#{Spree::TaxonGrid.table_name}.available_on < ?",Time.now])        
      end
    end
    alias_method :taxon_grids, :grids

    has_one     :taxon_grid, -> {where(["#{Spree::TaxonGrid.table_name}.available_on < ?",Time.now])}
    alias_method :taxon_grid, :grid
    
    after_initialize -> {
      self.taxon_grids.build(available_on:1.day.ago) if new_record?
    }
  end
end

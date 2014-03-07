module Spree
  Taxon.class_eval do
    has_many    :products, through: :taxon_grid, source: :products do
      def <<(p)
        t = proxy_association.owner
        Classification.create taxon: t, product: p, taxon_grid: t.try(:taxon_grid)
      end
      def push(p)
        t = proxy_association.owner
        Classification.create taxon: t, product: p, taxon_grid: t.try(:taxon_grid)
      end
    end

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

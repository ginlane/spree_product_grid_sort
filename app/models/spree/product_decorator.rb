module Spree
  Product.class_eval do
    has_many :grid_orders
    def self.grid_ordered(taxon)
      grid_table = Spree::GridOrder.table_name
      in_taxon(taxon).
        joins("LEFT JOIN #{grid_table} ON #{grid_table}.product_id = #{table_name}.id").
        order("#{grid_table}.position ASC")
    end
    def grid_order(taxon)
      taxon_id = taxon.is_a?(Spree::Taxon)? taxon.id : taxon
      grid_orders.where(taxon_id: taxon_id).first
    end
  end
end

module Spree
  Product.class_eval do
    has_many :grid_orders

    add_search_scope :in_taxon do |taxon|
      grid_table  = Spree::GridOrder.table_name
      taxon_table = Spree::Taxon.table_name
      class_table = Spree::Classification.table_name

      where(id: Classification.select("#{class_table}.product_id").
            joins(:taxon).
            where(taxon_table => { id: taxon.self_and_descendants.pluck(:id)})).

        joins("LEFT JOIN #{grid_table} ON #{grid_table}.product_id = #{table_name}.id").
        order("#{grid_table}.position ASC")
    end

    add_search_scope :grid_ordered do |taxon|
      in_taxon taxon
    end

    def grid_order(taxon)
      taxon_id = taxon.is_a?(Spree::Taxon)? taxon.id : taxon
      grid_orders.where(taxon_id: taxon_id).first
    end
  end
end

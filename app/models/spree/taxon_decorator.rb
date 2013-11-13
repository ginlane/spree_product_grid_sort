module Spree
  Taxon.class_eval do
    has_many :grid_orders
    has_many :ordered_products,->{
      order("#{Spree::GridOrder.table_name}.position ASC")
    }, through: :grid_orders, class_name: "Spree::Product"
  end
end

module Spree
  Taxon.class_eval do
    has_many :grid_orders
    has_many :ordered_products,->{
      order("#{Spree::GridOrder.table_name}.position ASC")
    }, through: :grid_orders, class_name: "Spree::Product"

    def all_child_products
      (products + children.includes(:products).map(&:products).flatten.compact).uniq
    end

    def unordered_products
      products - ordered_products
    end

    def ensure_ordered_products
      unordered_products.each do |p|
        grid_orders.create product_id:p.id
      end
    end
  end
end

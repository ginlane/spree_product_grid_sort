module Spree
  Product.class_eval do
    has_many :taxonomies, through: :grid_order
    has_many :grid_orders, -> { where order: :position }

    def grid_order(tax)
      tax = tax.root.taxonomy unless tax.is_a? ::Spree::Taxonomy
      grid_orders.where(taxonomy_id: tax.id).first
    end
  end
end

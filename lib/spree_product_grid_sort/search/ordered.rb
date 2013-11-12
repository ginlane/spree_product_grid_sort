module SpreeProductGridSort
  module Search
    module Ordered
      def ordered
        if taxon
          base_scope = Spree::Product.active
          base_scope.join(:grid_orders).where("#{Spree::GridOrder.table_name}.taxonomy_id" => taxon.taxonomy.id)
          base_scope.in_taxon taxon

        else
          retrieve_products
        end
      end
    end
  end
end

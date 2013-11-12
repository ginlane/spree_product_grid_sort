class AddPositionAndTaxonomyIdToClassifications < ActiveRecord::Migration
  def change
    add_column :spree_products_taxons, :position, :integer
  end
end

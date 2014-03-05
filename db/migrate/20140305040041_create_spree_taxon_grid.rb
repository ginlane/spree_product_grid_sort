class CreateSpreeTaxonGrid < ActiveRecord::Migration
  def change
    create_table :spree_taxon_grids do |t|
      t.date :available_on
      t.references :taxon

      t.timestamps
    end
    add_reference :spree_products_taxons, :taxon_grid, index: true
  end
end

class AddTaxonGridIdToTaxons < ActiveRecord::Migration
  def change
    add_reference :spree_taxons, :taxon_grid, index: true
  end
end

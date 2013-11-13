class CreateSpreeGridOrders < ActiveRecord::Migration
  def change
    create_table :spree_grid_orders do |t|
      t.references :taxon
      t.references  :product
      t.integer    :position
      t.timestamps
    end
  end
end
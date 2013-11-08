class CreateSpreeGridOrders < ActiveRecord::Migration
  def change
    create_table :spree_grid_orders do |t|
      t.references :product
      t.references :taxonomy
      t.integer :position
      t.timestamps
    end
  end
end

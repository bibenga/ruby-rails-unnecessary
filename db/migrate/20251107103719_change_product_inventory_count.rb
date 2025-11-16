class ChangeProductInventoryCount < ActiveRecord::Migration[8.1]
  def change
    change_column_default :products, :inventory_count, 0
    change_column_null :products, :inventory_count, false, 0
  end
end

class CreateProductCounters < ActiveRecord::Migration[8.1]
  def change
    create_table :product_counters do |t|
      t.references :product, null: false, foreign_key: true, index: { unique: true }

      t.integer :user_views_count, default: 0, null: false
      t.integer :anonymous_views_count, default: 0, null: false

      t.timestamps
    end
  end
end

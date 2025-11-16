class DropSessionsTable < ActiveRecord::Migration[8.1]
  # def change
  # end

  def up
    drop_table :sessions
  end

  def down
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token
      t.datetime :expires_at

      t.timestamps
    end
  end
end

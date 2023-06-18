class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :house, null: false, foreign_key: { to_table: :houses }

      t.string :title, null: false
      t.string :body

      t.timestamps
    end
  end
end

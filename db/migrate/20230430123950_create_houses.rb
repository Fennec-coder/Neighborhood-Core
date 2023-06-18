class CreateHouses < ActiveRecord::Migration[7.0]
  def change
    enable_extension "postgis"

    create_table :houses do |t|
      t.string :address
      t.st_point :location, geographic: true
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :houses, :location, using: :gist
  end
end

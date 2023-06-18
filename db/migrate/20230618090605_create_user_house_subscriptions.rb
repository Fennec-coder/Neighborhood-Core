class CreateUserHouseSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_house_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :house, null: false, foreign_key: true

      t.timestamps
    end
  end
end

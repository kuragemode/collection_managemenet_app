class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :purchase_price
      t.integer :current_market_price

      t.timestamps
    end
  end
end

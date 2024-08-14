class CreateTotalizers < ActiveRecord::Migration[6.1]
  def change
    create_table :totalizers do |t|
      t.float :total_products
      t.float :total_taxes
      t.references :report, null: false, foreign_key: true

      t.timestamps
    end
  end
end

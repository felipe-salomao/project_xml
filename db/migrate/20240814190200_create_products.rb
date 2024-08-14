class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.bigint :ncm
      t.bigint :cfop
      t.string :unity
      t.float :quantity
      t.float :value
      t.references :report, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateTaxes < ActiveRecord::Migration[6.1]
  def change
    create_table :taxes do |t|
      t.float :icms
      t.float :ipi
      t.float :pis
      t.float :cofins
      t.references :report, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :document
      t.string :name
      t.string :fantasy
      t.bigint :ie
      t.integer :ind_ie
      t.integer :crt
      t.integer :entity_type
      t.references :document_info, null: false, foreign_key: true

      t.timestamps
    end
  end
end

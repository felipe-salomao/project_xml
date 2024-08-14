class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :lgr
      t.bigint :nro
      t.string :cpl
      t.string :neighborhood
      t.bigint :mun
      t.string :uf
      t.string :cep
      t.bigint :cod_country
      t.string :country
      t.string :phone
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end

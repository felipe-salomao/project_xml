class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.text :file_data
      t.string :serie
      t.string :nNF
      t.datetime :dhEmi
      t.text :emit
      t.text :dest
      t.text :produtos
      t.text :impostos
      t.text :totalizadores

      t.timestamps
    end
  end
end

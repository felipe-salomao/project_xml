class RemoveColumnsFromReports < ActiveRecord::Migration[6.1]
  def change
    remove_column :reports, :file_data, :text
    remove_column :reports, :serie, :string
    remove_column :reports, :nNF, :string
    remove_column :reports, :dhEmi, :datetime
    remove_column :reports, :emit, :text
    remove_column :reports, :dest, :text
    remove_column :reports, :produtos, :text
    remove_column :reports, :impostos, :text
    remove_column :reports, :totalizadores, :text
  end
end

class AddXmlFileToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :xml_file, :string
  end
end

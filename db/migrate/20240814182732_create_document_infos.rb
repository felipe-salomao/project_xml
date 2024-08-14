class CreateDocumentInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :document_infos do |t|
      t.string :serie
      t.string :nnf
      t.datetime :dhemi
      t.references :report, null: false, foreign_key: true

      t.timestamps
    end
  end
end

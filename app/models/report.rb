class Report < ApplicationRecord
  mount_uploader :xml_file, XmlFileUploader

  has_one :document_info
  has_one :totalizer
  has_one :tax

  has_many :products
end

class Report < ApplicationRecord
  mount_uploader :xml_file, XmlFileUploader
end

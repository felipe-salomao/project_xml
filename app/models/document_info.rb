class DocumentInfo < ApplicationRecord
  belongs_to :report

  has_many :companies
end

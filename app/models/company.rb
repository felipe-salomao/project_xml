class Company < ApplicationRecord
  belongs_to :document_info

  has_one :address, dependent: :destroy

  enum entity_type: {
    emitter: 0,
    receiver: 1
  }
end

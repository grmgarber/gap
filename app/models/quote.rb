class Quote < ApplicationRecord
  belongs_to :property

  before_validation do |model|
    model.token = SecureRandom.hex unless model.token.present?
  end
end

class Quote < ApplicationRecord
  TOKEN_BYTES = 32
  belongs_to :property

  validates :token, length: {is: TOKEN_BYTES * 2}

  before_validation do |model|
    model.token = SecureRandom.hex(TOKEN_BYTES) unless model.token.present?
  end
end

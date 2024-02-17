# frozen_string_literal: true

class DepositProduct < ApplicationRecord
  belongs_to :product
  belongs_to :deposit
end

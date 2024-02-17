# frozen_string_literal: true

class Deposit < ApplicationRecord
  belongs_to :organization

  validates :name, presence: true
end

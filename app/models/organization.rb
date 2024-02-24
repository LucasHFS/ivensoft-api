# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :organization_users, dependent: :destroy
  has_many :users, through: :organization_users
  has_many :categories, dependent: :destroy
  has_many :makes, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :name, presence: true

  def default_deposit
    deposits.first
  end
end

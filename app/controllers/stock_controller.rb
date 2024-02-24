# frozen_string_literal: true

class StockController < ApplicationController
  before_action :authenticate_user!

  def index
    @deposit_products = current_organization.default_deposit.deposit_products.includes(:product)
  end
end

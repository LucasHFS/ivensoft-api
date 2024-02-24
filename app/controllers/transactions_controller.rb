# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_transaction!, only: %i[show]

  def index
    @transactions = current_organization.transactions.order(transactioned_at: :desc)
  end

  def show; end

  def create
    transaction_attributes.each do |product_transaction|
      Transaction.create!(
        transaction_type: product_transaction[:transaction_type],
        product_id: product_transaction[:product_id],
        quantity: product_transaction[:quantity],
        deposit_id: current_organization.default_deposit.id,
        transactioned_at: product_transaction[:transactioned_at],
        organization: current_organization
      )
    end

    render json: {}, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      errors: e.record.errors.full_messages
    }, status: :unprocessable_entity
  end

  private

  def transaction_params
    params.require(:transaction).permit(
      product_transactions: %i[quantity transaction_type product_id transactioned_at]
    )
  end

  def transaction_attributes
    transaction_params[:product_transactions].map do |product_transaction|
      raise ActionController::ParameterMissing, :transactioned_at if product_transaction[:transactioned_at].blank?

      product_transaction.merge(
        transactioned_at: Time.zone.parse(product_transaction[:transactioned_at])
      )
    end
  end

  def find_transaction!
    @transaction = current_organization.transactions.find(params[:id])
  end
end

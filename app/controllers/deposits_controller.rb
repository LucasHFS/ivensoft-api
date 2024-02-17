# frozen_string_literal: true

class DepositsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_deposit!, only: %i[show update destroy]

  def index
    @deposits = current_organization.deposits.order(:name)
  end

  def show; end

  def create
    @deposit = Deposit.new(deposit_params)
    @deposit.organization = current_organization

    if @deposit.save
      render :show, status: :created
    else
      render json: {
        errors: @deposit.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @deposit.update(deposit_params)
      render :show
    else
      render json: {
        errors: @deposit.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @deposit.destroy
      render json: {}, status: :no_content
    else
      render json: {
        errors: ['Não foi possivel excluir a deposito']
      }, status: :unprocessable_entity
    end
  end

  private

  def deposit_params
    params.require(:deposit).permit(:name)
  end

  def find_deposit!
    @deposit = current_organization.deposits.find(params[:id])
  end
end
